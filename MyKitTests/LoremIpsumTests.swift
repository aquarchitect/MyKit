//
//  LoremIpsumTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

final class LoremIpsumTests: XCTestCase {

    func testRandomElement() {
        let element = LoremIpsum.sharedInstance?.randomElement
        XCTAssert(!(element ?? "").isEmpty)
    }

    func testRandomSlice() {
        let slice = LoremIpsum.sharedInstance?.randomSlice.map { $0 }
        XCTAssert(!(slice ?? []).isEmpty)
    }
}
