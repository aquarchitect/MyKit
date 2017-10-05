// 
// ActionTrailingTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen. All rights reserved.
// 
// 

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import XCTest
@testable import MyKit

final class ActionTrailingTests: XCTestCase {

#if os(iOS)
    func testAction() {
        let expectation = self.expectation(description: #function).then {
            $0.expectedFulfillmentCount = 2
        }

        let button = UIButton()
        button.addAction({
            XCTAssert(type(of: $0) == UIButton.self)
            expectation.fulfill()
            Swift.print($0)
        }, for: .touchUpInside)

        button.handleAction()

        let gesture = UITapGestureRecognizer()
        gesture.addAction {
            XCTAssert(type(of: $0) == UITapGestureRecognizer.self)
            expectation.fulfill()
        }

        gesture.handleAction()

        wait(for: [expectation], timeout: 0.2)
    }
#elseif os(macOS)
    func testAction() {
        let expectation = self.expectation(description: #function).then {
            $0.expectedFulfillmentCount = 2
        }

        let button = NSButton()
        button.addAction {
            XCTAssert(type(of: $0) == NSButton.self)
            expectation.fulfill()
        }

        button.perform(button.action)

        let gesture = NSGestureRecognizer()
        gesture.addAction {
            XCTAssert(type(of: $0) == NSGestureRecognizer.self)
            expectation.fulfill()
        }

        gesture.perform(gesture.action)

        wait(for: [expectation], timeout: 0.2)
    }
#endif
}
