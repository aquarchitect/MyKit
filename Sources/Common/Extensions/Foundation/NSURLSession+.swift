/*
 * NSURLSession+.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

public extension NSURLSession {

    func data(`from` url: NSURL) -> Promise<[String: AnyObject]> {
        return Promise { callback in
            self.dataTaskWithURL(url) { data, _, error in
                // return immediately if error occurs
                if let _error = error { return callback(.Reject(_error)) }

                // return empty result if optional binding fails
                guard let _data = data else { return callback(.Fullfill([:])) }

                do {
                    let results = try NSJSONSerialization.JSONObjectWithData(_data, options: [])
                    callback(.Fullfill(results as? [String: AnyObject] ?? [:]))
                } catch {
                    callback(.Reject(error))
                }
            }.resume()
        }
    }
}