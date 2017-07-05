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
#elseif os(OSX)
import AppKit
#endif

@testable import MyKit

final class ActionTrailingTests: XCTestCase {

#if os(iOS)
    func testAction() {
        let button = UIButton()
        button.addAction({
            XCTAssert(type(of: $0) == UIButton.self)
        }, for: .touchUpInside)

        button.handleAction(button)

        let gesture = UITapGestureRecognizer()
        gesture.addAction {
            XCTAssert(type(of: $0) == UITapGestureRecognizer.self)
        }

        gesture.handleAction(gesture)
    }
#elseif os(OSX)
    func testAction() {
        let button = NSButton()
        button.addAction {
            XCTAssert(type(of: $0) == NSButton.self)
        }

        button.handleAction(button)

        let gesture = NSGestureRecognizer()
        gesture.addAction {
            XCTAssert(type(of: $0) == NSGestureRecognizer.self)
        }

        gesture.handleAction(gesture)
    }
#endif
}
