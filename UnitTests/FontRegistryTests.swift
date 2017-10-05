// 
// _FontLoadingTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import XCTest
@testable import MyKit

final class CustomFontTests: XCTestCase {

    func testCustomFontRegistry() {
#if os(iOS)
        let bundle = Bundle(identifier: "hainguyen.mykit-iOS")
#elseif os(macOS)
        let bundle = Bundle(identifier: "hainguyen.mykit-macOS")
#endif

        [
            ("Ionicons", "SymbolIcon"),
            ("Weather Icons", "OpenWeather")
        ].forEach {
            XCTAssertNotNil(Font.customFont(name: $0, size: 17, fromFile: $1, withExtension: "ttf", in: bundle))
        }
    }
}
