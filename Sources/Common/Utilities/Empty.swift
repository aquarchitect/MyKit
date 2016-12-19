/*
 * Empty.swift
 * MyKit
 *
 * Created by Hai Nguyen on 12/16/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

/**
 * `Empty` is designed to break a chaining asynchronous composition.
 * It does not carry much information for debugging.
 */
public struct Empty: Error {

    fileprivate init() {}
}

public extension Empty {

    static var `default`: Empty {
        return .init()
    }
}

extension Empty: CustomStringConvertible {

    public var description: String {
        return "Unharmed error"
    }
}
