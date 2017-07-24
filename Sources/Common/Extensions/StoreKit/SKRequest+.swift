//
// SKRequest+.swift
// MyKit
//
// Created by Hai Nguyen on 7/5/17.
// Copyright (c) 2017 Hai Nguyen.
//

import StoreKit

extension SKRequest: ObjectAssociating {

    public var subscription: Observable<[SKProduct]> {
        return getAssociatedObject()
            ?? Observable<[SKProduct]>()
            .then(setAssociatedObject)
    }
}
