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
        let buttonType = type(of: button)
        button.addAction({
            XCTAssert(buttonType == type(of: $0))
        }, for: .touchUpInside)

        let gesture = UIGestureRecognizer()
        let gestureType = type(of: gesture)
        gesture.addAction({
            XCTAssert(gestureType == type(of: $0))
        })

        button.executeAction()
        gesture.executeAction()
    }
#elseif os(OSX)
    func testAction() {
        let button = NSButton()
        let buttonType = type(of: button)
        button.addAction({
            XCTAssert(buttonType == type(of: $0))
        })

        let gesture = NSGestureRecognizer()
        let gestureType = type(of: gesture)
        gesture.addAction({
            XCTAssert(gestureType == type(of: $0))
        })

        button.executeAction()
        gesture.executeAction()
    }
#endif
}
