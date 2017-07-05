//
// CollectionExtensionTests.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen. All rights reserved.
// 

@testable import MyKit

final class CollectionExtensionTests: XCTestCase {}

extension CollectionExtensionTests {

    func testBinarySearchWithManyElements() {
        let sample = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
        XCTAssertEqual(sample.binarySearch(43), 13)
    }

    func testBinarySearchWithOneElement() {
        XCTAssertNil([5].binarySearch(10))
    }

    func testBinarySearchWithEmptyness() {
        XCTAssertNil([].binarySearch(10))
    }

    func testBinarySearchWithTwoElements() {
        XCTAssertEqual([1, 2].binarySearch(1), 0)
    }
}

extension CollectionExtensionTests {

    private func commonString(between str1: String, and str2: String, in range: Range<Int>? = nil) -> String {
        let c1s = Array(str1.characters)
        let c2s = Array(str2.characters)

        return String(c1s.repeatingElementsUsingLCS(byComparing: c2s, in: range))
    }

    func testRepeatingElementsUsingLCSWithManyElements() {
        XCTAssertEqual(commonString(between: "ABDC", and: "ACG"), "AC")
    }

    func testRepeatingElementsUsingLCSWithManyElementsInRange() {
        XCTAssertEqual(commonString(between: "ABDC", and: "ACG", in: 1..<6), "C")
    }

    func testRepeatingElementsUsingLCSWithSingleElement() {
        XCTAssertEqual(commonString(between: "A", and: "B"), "")
    }

    func testRepeatingElementsUsingLCSWithEmptyness() {
        XCTAssertEqual(commonString(between: "", and: ""), "")
    }
}

extension CollectionExtensionTests {

    private var sampleCharacters: ([Character], [Character]) {
        return ("ABDC".characters.map { $0 }, "ACG".characters.map { $0 })
    }

    // Unfortunately, the current Swift does not allow extension
    // of a type with constraints to conform a protocol.
    // This is a naive test but it does the job.
    func testDiffingElementsUsingLCS() {
        let (c1s, c2s) = sampleCharacters
        let changes = c1s.compareUsingLCS(c2s)

        XCTAssertEqual(changes.map({ $0.isDeleted }), [true, true, false])
        XCTAssertEqual(changes.map({ $0.value.index }), [1, 2, 2])
        XCTAssertEqual(changes.map({ $0.value.element }), ["B", "D", "G"])
    }

    func testDiffingIndexesUsingLCS() {
        let (c1s, c2s) = sampleCharacters
        let (deletes1, inserts1) = c1s.compareOptimallyUsingLCS(
            c2s,
            transformer: IndexPath(index: 0).appending
        )
        let (deletes2, inserts2) = c1s.compareOptimallyUsingLCS(
            c2s,
            in: 1 ..< 6,
            transformer: IndexPath(index: 0).appending
        )

        XCTAssertEqual(deletes1, deletes2)
        XCTAssertEqual(inserts1, inserts2)
    }
}

