/*
 * AnyIterator+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

#if swift(>=3.0)
public func + <T>(lhs: AnyIterator<T>, rhs: AnyIterator<T>) -> AnyIterator<T> {
    return AnyIterator { lhs.next() ?? rhs.next() }
}
#else
#endif
