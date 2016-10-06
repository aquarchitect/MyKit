/*
 * CollectionExtensionTests.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen. All rights reserved.
 */

@testable import MyKit

final class CollectionExtensionTests: XCTestCase {}

extension CollectionExtensionTests {

    func testBinarySearchWithManyElements() {
        let sample = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
        XCTAssertEqual(sample.binarySearch(element: 43), 13)
    }

    func testBinarySearchWithOneElement() {
        XCTAssertNil([5].binarySearch(element: 10))
    }

    func testBinarySearchWithEmptyness() {
        XCTAssertNil([].binarySearch(element: 10))
    }
}

extension CollectionExtensionTests {

    private func commonString(between str1: String, and str2: String) -> String {
        let c1s = str1.characters.map { $0 }
        let c2s = str2.characters.map { $0 }

        return String(c1s.repeatingElements(byComparing: c2s))
    }

    func testRepeatingElementsWithManyElements() {
        XCTAssertEqual(commonString(between: "ABDC", and: "ACG"), "AC")
    }

    func testRepeatingElementsWithOneElement() {
        XCTAssertEqual(commonString(between: "A", and: "B"), "")
    }

    func testRepeatingElementsWithEmptyness() {
        XCTAssertEqual(commonString(between: "", and: ""), "")
    }
}

extension CollectionExtensionTests {

    private var sampleCharacters: ([Character], [Character]) {
        return ("ABDC".characters.map { $0 }, "ACG".characters.map { $0 })
    }

    /*
     * Unfortunately, the current Swift does not allow extension
     * of a type with constraints to conform a protocol.
     * This is a naive test but it does the job.
     */
    func testChangingIndexesAndElements() {
        let (c1s, c2s) = sampleCharacters
        let changes = c1s.compare(c2s)

        XCTAssertEqual(changes.map { $0.isDeleted }, [true, true, false])
        XCTAssertEqual(changes.map { $0.value.index }, [1, 2, 2])
        XCTAssertEqual(changes.map { $0.value.element }, ["B", "D", "G"])
    }

    func testChangingIndexPaths() {
        let (c1s, c2s) = sampleCharacters
        let changes = c1s.compare(c2s, section: 0)

        XCTAssertEqual(changes.reloads, [IndexPath(indexes: [0, 2])])
        XCTAssertEqual(changes.deletes, [IndexPath(indexes: [0, 1])])
    }
}
