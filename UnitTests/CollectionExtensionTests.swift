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

extension CollectionExtensionTests {

    fileprivate struct Cell {

        let title: String
        let hexColorUInt: UInt
        let isSelected: Bool
        let shortcut: String?
    }

    private var sample1s: [Cell] {
        return [
            Cell(title: "Search", hexColorUInt: 0, isSelected: false, shortcut: "F"),
            Cell(title: "Pesonal", hexColorUInt: 1, isSelected: true, shortcut: "1"),
            Cell(title: "Duende", hexColorUInt: 2, isSelected: false, shortcut: "2"),
            Cell(title: "New", hexColorUInt: 3, isSelected: false, shortcut: "N")
        ]
    }

    private var sample2s: [Cell] {
        return [
            Cell(title: "Search", hexColorUInt: 0, isSelected: false, shortcut: "F"),
            Cell(title: "Pesonal", hexColorUInt: 1, isSelected: false, shortcut: "1"),
            Cell(title: "Duende", hexColorUInt: 2, isSelected: true, shortcut: "2"),
            Cell(title: "New", hexColorUInt: 3, isSelected: false, shortcut: "N")
        ]
    }

    private var sample3s: [Cell] {
        return [
            Cell(title: "Search", hexColorUInt: 0, isSelected: false, shortcut: "F"),
            Cell(title: "Work", hexColorUInt: 1, isSelected: true, shortcut: "1"),
            Cell(title: "New", hexColorUInt: 3, isSelected: true, shortcut: "N")
        ]
    }

    func testDiffingIndexesUsingHeckel1() {
        let (deletes, inserts, moves, updates) = sample1s.compareUsingHeckel(sample2s)

        XCTAssertEqual(deletes, [])
        XCTAssertEqual(inserts, [])
        XCTAssertEqual(moves.map({ $0.0 }), [])
        XCTAssertEqual(moves.map({ $0.1 }), [])
        XCTAssertEqual(updates, [1, 2])
    }

    func testDiffingIndexesUsingHeckel2() {
        let (deletes, inserts, moves, updates) = sample1s.compareUsingHeckel(sample3s)

        XCTAssertEqual(deletes, [1, 2])
        XCTAssertEqual(inserts, [1])
        XCTAssertEqual(moves.map({ $0.0 }), [])
        XCTAssertEqual(moves.map({ $0.1 }), [])
        XCTAssertEqual(updates, [2])
    }
}

extension CollectionExtensionTests.Cell: Hashable {

    var hashValue: Int {
        return title.appending(shortcut ?? "").hashValue
            + hexColorUInt.hashValue
    }
}

extension CollectionExtensionTests.Cell: Equatable {

    static func == (lhs: CollectionExtensionTests.Cell, rhs: CollectionExtensionTests.Cell) -> Bool {
        return lhs.title == rhs.title
            && lhs.hexColorUInt == rhs.hexColorUInt
            && lhs.isSelected == rhs.isSelected
            && lhs.shortcut == rhs.shortcut
    }
}
