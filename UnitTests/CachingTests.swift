// 
// CachingTests.swift
// MyKit
// 
// Created by Hai Nguyen on 1/3/17.
// Copyright (c) 2017 Hai Nguyen.
// 

final class CachingTests: XCTestCase {

    func testObjectFetching() {
        let expectation = self.expectation(description: #function)

#if os(iOS)
        let observable = UIImage.fetchObject(
            for: "Testing",
            with: .lift(
                UIImage.render(.init(string: "Testing"))!,
                on: .global(qos: .background)
            )
        )
#elseif os(OSX)
        let observable = NSImage.fetchObject(
            for: "Testing",
            with: .lift(
                NSImage.render(.init(string: "Testing")),
                on: .global(qos: .background)
            )
        )
#endif

        observable.onNext {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }.onError {
            XCTFail($0.localizedDescription)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }
}
