/*
 * ActionTrailingTests.swift
 * MyKit
 *
 * Created by Hai Nguyen on 10/2/16
 * Copyright (c) 2016 Hai Nguyen. All rights reserved.
 *
 */

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@testable import MyKit

final class ActionTrailingTests: XCTestCase {

    func testAction() {
        let expectation = self.expectation(description: #function)

        UIButton().then {
            $0.addAction({
                XCTAssertNotNil($0)
                expectation.fulfill()
            }, for: .touchUpInside)
        }.executeAction()

        waitForExpectations(timeout: 5) {
            XCTAssertNil($0)
        }
    }
}
