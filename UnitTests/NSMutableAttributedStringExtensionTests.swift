/*
 * NSMutableAttributedStringExtensionTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen. All rights reserved.
 *
 */

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

@testable import MyKit

final class NSMutableAttributedStringExtensionTests: XCTestCase {

    func testAddingAttributes() {
        NSMutableAttributedString(string: "Foo").then {
            $0.addFont(.systemFont(ofSize: 17))
            $0.addColor(.white)
            $0.addAlignment(.center)
            $0.addKern(3)
            $0.addBaseline(-3)
        }.then {
            XCTAssertNotNil($0)
        }

        SymbolIcon("\u{F122}")
            .attributedString(ofSize: 23)
            .then { XCTAssertNotNil($0) }
    }
}
