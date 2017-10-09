//
// CGRectExtensionTests.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

import XCTest
import MyKit

final class CGRectExtensionTests: XCTestCase {}

extension CGRectExtensionTests {

    func testTileFittingSlicing() {
        let rect = CGRect(x: 0, y: 0, width: 40, height: 60)
        let enumerator = { rect.slices(rect, intoTilesOf: CGSize(width: 20, height: 30)) }

        XCTAssertEqual(
            enumerator().map({ $0.rect }),
            [
                CGRect(x: 0, y: 0, width: 20, height: 30),
                CGRect(x: 20, y: 0, width: 20, height: 30),
                CGRect(x: 0, y: 30, width: 20, height: 30),
                CGRect(x: 20, y: 30, width: 20, height: 30)
            ]
        )

        XCTAssertEqual(enumerator().map({ $0.row }), [0, 0, 1, 1])
        XCTAssertEqual(enumerator().map({ $0.column }), [0, 1, 0, 1])
    }

    func testTileExtraSlicing() {
        let rect = CGRect(x: 0, y: 0, width: 50, height: 70)
        let enumerator = { rect.slices(rect, intoTilesOf: CGSize(width: 20, height: 30)) }

        XCTAssertEqual(
            enumerator().map({ $0.rect }),
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

        XCTAssertEqual(enumerator().map({ $0.row }), [0, 0, 0, 1, 1, 1, 2, 2, 2])
        XCTAssertEqual(enumerator().map({ $0.column }), [0, 1, 2, 0, 1, 2, 0, 1, 2])
    }

    func testTileMiddleSlicing() {
        let enumerator = {
            CGRect(x: 0, y: 0, width: 50, height: 70).slices(
                CGRect(x: 25, y: 20, width: 20, height: 30),
                intoTilesOf: CGSize(width: 20, height: 30)
            )
        }

        XCTAssertEqual(
            enumerator().map({ $0.rect }),
            [
                CGRect(x: 20, y: 0, width: 20, height: 30),
                CGRect(x: 40, y: 0, width: 10, height: 30),
                CGRect(x: 20, y: 30, width: 20, height: 30),
                CGRect(x: 40, y: 30, width: 10, height: 30)
            ]
        )

        XCTAssertEqual(enumerator().map({ $0.row }), [0, 0, 1, 1])
        XCTAssertEqual(enumerator().map({ $0.column }), [1, 2, 1, 2])
    }
}
