//
// SKProductsRequest+.swift
// MyKit
//
// Created by Hai Nguyen on 7/5/17.
// Copyright (c) 2017 Hai Nguyen.
//

import StoreKit

public extension SKProductsRequest {

    func fetch() -> Observable<[SKProduct]> {
        defer { self.start() }
        self.delegate = self
        return subscription
    }
}

extension SKProductsRequest: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        request.subscription.update(response.products)
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        request.subscription.update(error)
    }
}
