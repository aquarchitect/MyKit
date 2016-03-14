//
//  CustomFontTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/13/16.
//  
//

@testable import MyKit

final class CustomFontTests: XCTestCase {

    func testsFontOf<T: CustomFont>(type: T.Type) {
        [("Ionicons", "SymbolIcon"), ("Weather Icons", "WeatherFont")].forEach {
            XCTAssertNotNil(T.fontWith(name: $0.0, size: 17, fromFile: $0.1))
        }
    }

    func testsCustomFontRegister() {
        XCTAssertNotNil(NSBundle.defaultBundle)

        #if os(iOS)
            testsFontOf(UIFont.self)
        #elseif os(OSX)
            testsFontOf(NSFont.self)
        #endif
    }
}