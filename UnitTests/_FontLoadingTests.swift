/*
 * _FontLoadingTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

@testable import MyKit

final class CustomFontTests: XCTestCase {

    func testsFontInstanceOf<T: _FontLoading>(type: T.Type) {
        [("Ionicons", "SymbolIcon"), ("Weather Icons", "OpenWeather")].forEach {
            XCTAssertNotNil(T.font(name: $0.0, size: 17, fromFile: $0.1))
        }
    }

    func testsCustomFontRegister() {
        XCTAssertNotNil(Bundle.default)

#if os(iOS)
        testsFontInstanceOf(type: UIFont.self)
#elseif os(OSX)
        testsFontInstanceOf(type: NSFont.self)
#endif
    }
}
