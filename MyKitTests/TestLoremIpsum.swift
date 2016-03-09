//
//  TestLoremIpsum.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

final class TestLoremIpsum: XCTestCase {

    func testRandomElement() {
        let element = LoremIpsum.sharedInstance?.randomElement
        XCTAssert(!(element ?? "").isEmpty)
    }

    func testRandomSlice() {
        let slice = LoremIpsum.sharedInstance?.randomSlice.map { $0 }
        XCTAssert(!(slice ?? []).isEmpty)
    }
}
