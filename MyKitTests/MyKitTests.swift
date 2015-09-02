//
//  MyKitTests.swift
//  MyKitTests
//
//  Created by Hai Nguyen on 8/31/15.
//
//

class MyKitTests: XCTestCase {

    var lorem = LoremIpsum()

    func testRangeArbitrary() {
        let range = 1..<5
        (0...100).forEach { _ in
            let rand = range.arbitrary()
            XCTAssertLessThanOrEqual(range.startIndex, rand)
            XCTAssertGreaterThan(range.endIndex, rand)
        }
    }

    func testLoremIsNil() {
        XCTAssert(lorem != nil)
    }

    func testLoremGenerator() {
        (0...100).forEach { _ in
            let range = 1...5
            let string = lorem?.arbitraryByWords(range)
            let count = string?.characters.split(" ").count
            XCTAssertGreaterThanOrEqual(range.count, count!)
        }
    }
}