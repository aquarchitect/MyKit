//
//  CustomFontTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/13/16.
//  
//

@testable import MyKit

final class CustomFontTests: XCTestCase {

    func testsFontInstanceOf<T: _RuntimeFontLoadable>(type: T.Type) {
        [("Ionicons", "SymbolIcon"), ("Weather Icons", "OpenWeather")].forEach {
            XCTAssertNotNil(T.fontWith(name: $0.0, size: 17, fromFile: $0.1))
        }
    }

    func testsCustomFontRegister() {
        XCTAssertNotNil(NSBundle.defaultBundle)

#if os(iOS)
        testsFontInstanceOf(UIFont.self)
#elseif os(OSX)
        testsFontInstanceOf(NSFont.self)
#endif
    }
}