// 
// URLSession+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import Foundation

public extension URLSession {

    func dataTask(with url: URL) -> Observable<(Data, URLResponse)> {
        let observable = Observable<(Data, URLResponse)>()
        self.dataTask(
            with: url,
            completionHandler: { observable.update(zip($0.0, $0.1), $0.2) }
        ).resume()
        return observable
    }

    func dataTask(with request: URLRequest) -> Observable<(Data, URLResponse)> {
        let observable = Observable<(Data, URLResponse)>()
        self.dataTask(
            with: request,
            completionHandler: { observable.update(zip($0.0, $0.1), $0.2) }
        ).resume()
        return observable
    }
}
