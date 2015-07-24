//
//  Boxing.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class Box<T> {

    public let unbox: T

    public init(_ value: T) {
        self.unbox = value
    }
}
