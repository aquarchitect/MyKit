//
//  LoremIpsumTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

@testable import MyKitOSX

final class LoremIpsumTests: XCTestCase {

    let lorem = try? LoremIpsum()

    func testLorem() {
        let slice = lorem?.randomSlice
        print(slice)
        print(slice?.count)
        print(slice?.joinWithSeparator(" "))

        XCTAssertTrue(true)
    }
}
