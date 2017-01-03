/*
 * CachingTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 1/3/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

final class CachingTests: XCTestCase {

    func testObjectFetching() {
        let expectation = self.expectation(description: #function)

#if os(iOS)
        typealias Image = UIImage
#elseif os(OSX)
        typealias Image = NSImage
#endif

        Image.fetchObject(for: "Testing", with: {
            .lift(on: .global(qos: .background)) {
                let image = Image.render(.init(string: "Testing"))
#if os(iOS)
                if let _image = image {
                    return _image
                } else {
                    throw Empty.default
                }
#elseif os(OSX)
                return image
#endif
            }
        }).onNext {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) { XCTAssertNil($0) }
    }
}
