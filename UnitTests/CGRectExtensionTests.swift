//
// CGRectExtensionTests.swift
// MyKit
//
// Created by Hai Nguyen on 7/29/17.
// Copyright (c) 2017 Hai Nguyen.
//

import MyKit

final class CGRectExtensionTests: XCTestCase {}

extension CGRectExtensionTests {

    func testTileFittingSlicing() {
        XCTAssertEqual(
            Array(CGRect(x: 0, y: 0, width: 40, height: 60)
                .slicesIntoTiles(of: CGSize(width: 20, height: 30))),
            [
                CGRect(x: 0, y: 0, width: 20, height: 30),
                CGRect(x: 20, y: 0, width: 20, height: 30),
                CGRect(x: 0, y: 30, width: 20, height: 30),
                CGRect(x: 20, y: 30, width: 20, height: 30)
            ]
        )
    }

    func testTileExtraSlicing() {
        XCTAssertEqual(
            Array(CGRect(x: 0, y: 0, width: 50, height: 70)
                .slicesIntoTiles(of: CGSize(width: 20, height: 30))),
            [
                CGRect(x: 0, y: 0, width: 20, height: 30),
                CGRect(x: 20, y: 0, width: 20, height: 30),
                CGRect(x: 40, y: 0, width: 10, height: 30),
                CGRect(x: 0, y: 30, width: 20, height: 30),
                CGRect(x: 20, y: 30, width: 20, height: 30),
                CGRect(x: 40, y: 30, width: 10, height: 30),
                CGRect(x: 0, y: 60, width: 20, height: 10),
                CGRect(x: 20, y: 60, width: 20, height: 10),
                CGRect(x: 40, y: 60, width: 10, height: 10),
            ]
        )
    }
}
