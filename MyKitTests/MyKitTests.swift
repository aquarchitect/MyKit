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

//    func testLoremWordGeneratorWithRange(range: Range<Int>) {
//        let string = lorem?.arbitraryByWords(range)
//        if let count = string?.componentsSeparatedByString(" ").count {
//            XCTAssertGreaterThanOrEqual(range.count, count)
//        } else { XCTAssertNil(string) }
//    }
//
    func testLoremWordGeneratorWithCount(count: Int) {
        let string = lorem?.arbitraryByWords(count, fromStart: false)
        let count = string?.componentsSeparatedByString(" ").count
        XCTAssertEqual(count, count)
    }

    func testLoremWordGenerator() {
        testLoremWordGeneratorWithCount(5)
    }
}