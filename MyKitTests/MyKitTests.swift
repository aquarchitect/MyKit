//
//  MyKitTests.swift
//  MyKitTests
//
//  Created by Hai Nguyen on 8/31/15.
//
//

class MyKitTests: XCTestCase {

    var lorem = LoremIpsum()
    
    func testLoremGenerator() {
        (0...10).forEach { _ in
            let range = 0...5
            let string = lorem.arbitraryByWords(range)
            let count = string.characters.split(" ").count
            print(string)
            XCTAssert(count <= range.endIndex)
        }
    }
}