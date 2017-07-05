//
// SKRequest+.swift
// MyKit
//
// Created by Hai Nguyen on 7/5/17.
// Copyright (c) 2017 Hai Nguyen.
//

import StoreKit

private var GlobalToken: UInt8 = 0

extension SKRequest {

    var subscription: Observable<[SKProduct]> {
        return getAssociatedObject()
            ?? Observable<[SKProduct]>()
            .then(setAssociatedObject)
    }
}
