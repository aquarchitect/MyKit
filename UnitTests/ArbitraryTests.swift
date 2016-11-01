/*
 * ArbitraryTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/26/16.
 * Copyright (c) 2016 Hai Nguyen.
 */

final class ArbitraryTests: XCTestCase {

    func testRandomElement() {
        XCTAssertFalse(Arbitrary.sentence.isEmpty)
    }
}
