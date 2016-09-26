/*
 * AnyIterator+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

public func + <T>(lhs: AnyIterator<T>, rhs: AnyIterator<T>) -> AnyIterator<T> {
    return AnyIterator { lhs.next() ?? rhs.next() }
}
