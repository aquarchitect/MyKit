//
//  MyKitTests.swift
//  MyKitTests
//
//  Created by Hai Nguyen on 8/31/15.
//
//

@testable import MyKitOSX

class MyKitTests: XCTestCase {

    let lorem = try? LoremIpsum()

    func testLoremWordGeneratorWithCount(count: Int) {
        let string = lorem?.arbitraryByWords(count, fromStart: false)
        let count = string?.componentsSeparatedByString(" ").count
        XCTAssertEqual(count, count)
    }

    func testLoremWordGenerator() {
        testLoremWordGeneratorWithCount(5)
    }
}