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

#if true
        Image.fetchObject(
            forKey: "Test",
            contructIfNeeded: Image.render(NSAttributedString(string: "Test"))
        ).inBackground().onSuccess {
            XCTAssertNotNil($0.cgImage)
            expectation.fulfill()
        }.resolve()
#else
        Image.fetchObject(
            forKey: "Testing",
            contructIfNeeded: .lift(
                NSImage.render(.init(string: "Testing")),
                on: .global(qos: .background)
            )
        ).onNext {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }
#endif

        waitForExpectations(timeout: 2, handler: nil)
    }
}
