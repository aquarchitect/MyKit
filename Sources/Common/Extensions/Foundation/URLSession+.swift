// 
// URLSession+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

public extension URLSession {

#if true
    func dataTask(with url: URL) -> Promise<(Data, URLResponse)> {
        return Promise { callback in
            self.dataTask(
                with: url,
                completionHandler: { (Result.init >>> callback)((zip($0, $1), $2)) }
            ).resume()
        }
    }
#else
    func dataTask(with url: URL) -> Observable<(Data, URLResponse)> {
        let observable = Observable<(Data, URLResponse)>()
        self.dataTask(
            with: url,
            completionHandler: { (Result.init >>> observable.update)((zip($0.0, $0.1), $0.2)) }
        ).resume()
        return observable
    }
#endif

#if true
    func dataTask(with request: URLRequest) -> Promise<(Data, URLResponse)> {
        return Promise { callback in
            self.dataTask(
                with: request,
                completionHandler: { (Result.init >>> callback)((zip($0, $1), $2)) }
            ).resume()
        }
    }
#else
    func dataTask(with request: URLRequest) -> Observable<(Data, URLResponse)> {
        let observable = Observable<(Data, URLResponse)>()
        self.dataTask(
            with: request,
            completionHandler: { (Result.init >>> observable.update)((zip($0.0, $0.1), $0.2)) }
        ).resume()
        return observable
    }
#endif
}
