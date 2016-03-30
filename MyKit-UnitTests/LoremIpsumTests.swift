//
//  LoremIpsumTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

final class LoremIpsumTests: XCTestCase {

    private let loremIpsum = LoremIpsum.sharedInstance

    func testLoremIpsum() {
        XCTAssertNotNil(loremIpsum)
        XCTAssert(!(loremIpsum?.randomElement ?? "").isEmpty)
    }
}
