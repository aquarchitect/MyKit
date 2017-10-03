//
// CachingTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
// 

final class CachingTests: XCTestCase {

    func testImageFetching() {
        let expectation = self.expectation(description: #function)

#if os(iOS)
        typealias Image = UIImage
#else
        typealias Image = NSImage
#endif

        Image.fetchObject(
            forKey: "Test",
            contructIfNeeded: Image.render(.init(string: "Testing"))
        ).inBackground().onSuccess {
            XCTAssertNotNil($0.cgImage)
            expectation.fulfill()
        }.resolve()

        waitForExpectations(timeout: 2, handler: nil)
    }
}
