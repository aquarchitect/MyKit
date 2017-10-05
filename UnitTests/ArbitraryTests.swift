//
// ArbitraryTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import XCTest
import MyKit

final class ArbitraryTests: XCTestCase {

    func testRandomElement() {
        XCTAssertFalse(Arbitrary.sentence.isEmpty)
    }
}
