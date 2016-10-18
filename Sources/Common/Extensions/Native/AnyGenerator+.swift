/*
 * AnyGenerator+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

#if swift(>=3.0)
#else
public func + <T>(lhs: AnyGenerator<T>, rhs: AnyGenerator<T>) -> AnyGenerator<T> {
    return AnyGenerator { lhs.next() ?? rhs.next() }
}
#endif
