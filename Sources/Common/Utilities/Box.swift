// 
// Box.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

/// _Box_ converts value semantic to reference remantic.
public class Box<T> {

    public let value: T

    public init(_ value: T) {
        self.value = value
    }
}
