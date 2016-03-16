//
//  TaskSchedulerTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/11/16.
//  
//

final class TaskSchedulerTests: XCTestCase {

    private let taskScheduler = TaskScheduler()

    func testFullfilledTaskScheduler() {
        let expectation = expectationWithDescription(__FUNCTION__)

        taskScheduler.schedule(1) { expectation.fulfill() }
        waitForExpectationsWithTimeout(2) { XCTAssertNil($0) }
    }

    func testRejectedTaskScheduler() {
        let expectation = expectationWithDescription(__FUNCTION__)

        taskScheduler.schedule(1) { XCTFail() }

        delay(0.5) {
            self.taskScheduler.cancel()
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { XCTAssertNil($0) }
    }
}