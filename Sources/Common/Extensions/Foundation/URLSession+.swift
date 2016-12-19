/*
 * URLSession+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import Foundation

public extension URLSession {

    func dataTask(with url: URL) -> Observable<(Data, URLResponse)> {
        let observable = Observable<(Data, URLResponse)>()
        self.dataTask(with: url) { observable.update(zip($0.0, $0.1), $0.2) }
        return observable
    }
}
