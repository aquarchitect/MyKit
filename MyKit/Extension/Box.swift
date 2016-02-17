//
//  Box.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/18/16.
//
//

public class Box<T> {

    public let unbox: T

    public init(_ value: T) {
        self.unbox = value
    }
}

extension Box: Then {}