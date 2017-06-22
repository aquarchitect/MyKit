// 
// ObservableTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

@testable import MyKit

final class ObservableTests: XCTestCase {

    func testLift() {
        let expectation = self.expectation(description: #function)

        Observable.lift("Test").onNext {
            XCTAssertEqual($0, "Test")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2) {
            XCTAssertNil($0)
        }
    }

    func testMap() {
        let expectation = self.expectation(description: #function)

        let observable = Observable<String>()
        observable
            .map { $0 + " World" }
            .onNext {
                XCTAssertEqual($0, "Hello World")
                expectation.fulfill()
            }

        observable.update("Hello")

        waitForExpectations(timeout: 2) {
            XCTAssertNil($0)
        }
    }

    func testFlatMap() {
        let expectation = self.expectation(description: #function)

        var results: [String] = []
        let main = Observable<Int>()

        main.flatMap { value in
            Observable.lift("\(value)")
        }.onNext {
            results.append($0)
        }

        main.update(1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(results, ["1"])
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3) {
            XCTAssertNil($0)
        }
    }

    func testFlatMapLastest() {
        let firstExpectation = self.expectation(description: #function)
        let secondExpectation = self.expectation(description: #function)

        var result: [String] = []
        let observable = Observable<Int>()
        observable.flatMapLatest { value -> Observable<String> in
            let innerObservable = Observable<String>()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                innerObservable.update("\(value)")
            }

            return innerObservable
        }.onNext {
            result.append($0)
        }

        [1, 2].forEach(observable.update)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            observable.update(3)
            firstExpectation.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertEqual(result, ["2", "3"])
            secondExpectation.fulfill()
        }

        waitForExpectations(timeout: 6) {
            XCTAssertNil($0)
        }
    }

    func testDelay() {
        let expectation = self.expectation(description: #function)

        let observable = Observable<String>()
        observable.delay(4)
            .map { $0 + " World" }
            .onNext {
                XCTAssertEqual($0, "Hello World")
                expectation.fulfill()
            }

        observable.update("Hello")

        waitForExpectations(timeout: 6) {
            XCTAssertNil($0)
        }
    }

    func testDebounce() {
        let firstExpectation = self.expectation(description: "First Expectation")
        let secondExepectation = self.expectation(description: "Second Expectation")

        var results: [String] = []

        let observable = Observable<String>()
        observable.throttle(1).onNext({ results.append($0) })
        ["A", "B", "C"].forEach(observable.update)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            observable.update("D")
            XCTAssertEqual(results, ["C"])
            firstExpectation.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertEqual(results, ["C", "D"])
            secondExepectation.fulfill()
        }

        waitForExpectations(timeout: 5) {
            XCTAssertNil($0)
        }
    }

    func testBackground() {
        let expectation = self.expectation(description: #function)

        Observable.lift("Test", on: .global(qos: .background)).onNext { _ in
            XCTAssertFalse(Thread.isMainThread)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { XCTAssertNil($0) }
    }
}
