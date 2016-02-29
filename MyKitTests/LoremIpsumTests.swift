//
//  LoremIpsumTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/17/16.
//  
//

@testable import MyKitOSX

final class LoremIpsumTests: XCTestCase {

    func testLorem() {
        print(LoremIpsum.sharedInstance?.first)
        print(LoremIpsum.sharedInstance?.last)

        XCTAssertTrue(true)
    }
}
