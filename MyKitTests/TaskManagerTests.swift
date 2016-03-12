//
//  TaskManagerTests.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/11/16.
//  
//

final class TaskManagerTests: XCTestCase {

    private let taskManager = TaskManager()

    func testFullfilledTaskManager() {
        let expectation = expectationWithDescription(__FUNCTION__)

        taskManager.schedule(1) { expectation.fulfill() }
        waitForExpectationsWithTimeout(2) { XCTAssertNil($0) }
    }

    func testRejectedTaskManager() {
        let expectation = expectationWithDescription(__FUNCTION__)

        taskManager.schedule(1) { XCTFail() }

        delay(0.5) {
            self.taskManager.cancel()
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { XCTAssertNil($0) }
    }
}