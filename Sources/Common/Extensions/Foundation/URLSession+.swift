/*
 * URLSession+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

public extension URLSession {

    func dataTask(with url: URL) -> Promise<[String: AnyObject]> {
        return Promise { callback in
            self.dataTask(with: url) { data, _, error in
                if let _error = error {
                    return callback(.reject(_error))
                } else if let _data = data {
                    do {
                        let results = try JSONSerialization.jsonObject(with: _data, options: [])
                        callback(.fulfill(results as? [String: AnyObject] ?? [:]))
                    } catch {
                        callback(.reject(error))
                    }
                } else {
                    callback(.reject(PromiseError.empty))
                }
            }.resume()
        }
    }
}
