//
//  MyKitTests.swift
//  MyKitTests
//
//  Created by Hai Nguyen on 8/31/15.
//
//

@testable import MyKitOSX

class MyKitTests: XCTestCase {

    var lorem = LoremIpsum()

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

    func testToday() {
        let timeSystem = TimeSystem.shareInstance
        print(timeSystem.today)
        print(timeSystem.calendar.dateFromComponents(timeSystem.today.components([.Year, .Month])))
    }
}