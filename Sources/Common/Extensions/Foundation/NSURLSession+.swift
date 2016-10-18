/*
 * NSURLSession+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

#if swift(>=3.0)
#else
public extension NSURLSession {

    func dataTaskWithURL(url: NSURL) -> Promise<(NSData, NSURLResponse)> {
        return Promise { callback in
            self.dataTaskWithURL(url) { data, response, error in
                if let _error = error {
                    return callback(.reject(_error))
                } else if let _response = response, let _data = data {
                    callback(.fulfill((_data, _response)))
                } else {
                    callback(.reject(PromiseError.empty))
                }
                }.resume()
        }
    }
}
#endif

