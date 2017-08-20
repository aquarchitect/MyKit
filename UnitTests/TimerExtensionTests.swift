// 
// TimerExtensionTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

@testable import MyKit

final class TimerExtensionTests: XCTestCase {}

extension TimerExtensionTests {

    func testEveryAndCountdown() {
        let count: UInt = 5

        let expectation = self
            .expectation(description: #function)
            .then({ $0.expectedFulfillmentCount = count + 1 })

        Timer.countdown(
            0.5, from: count,
            block: { _ in expectation.fulfill() }
        ).then {
            RunLoop.current.add($0, forMode: .defaultRunLoopMode)
        }

        waitForExpectations(timeout: 4, handler: nil)
    }
}
