//
// TreeNodeTests.swift
// MyKit
//
// Created by Hai Nguyen on 7/28/17.
// Copyright (c) 2017 Hai Nguyen.
//

import XCTest
import MyKit

final class TreeNodeTests: XCTestCase {}

extension TreeNodeTests {

    private var tree: TreeNode<String> {
        let beverage = TreeNode(value: "beverage")

        let hot = TreeNode(value: "hot")
        let cold = TreeNode(value: "cold")

        let tea = TreeNode(value: "tea")
        let coffee = TreeNode(value: "coffee")
        let cocoa = TreeNode(value: "cocoa")

        let black = TreeNode(value: "black")
        let green = TreeNode(value: "green")
        let chai = TreeNode(value: "chai")

        let soda = TreeNode(value: "soda")
        let milk = TreeNode(value: "milk")

        let gingerAle = TreeNode(value: "ginger ale")
        let bitterLemon = TreeNode(value: "bitter lemon")

        [hot, cold].forEach(beverage.addChild)
        [tea, coffee, cocoa].forEach(hot.addChild)
        [black, green, chai].forEach(tea.addChild)
        [soda, milk].forEach(cold.addChild)
        [gingerAle, bitterLemon].forEach(soda.addChild)

        return beverage
    }

    func testIterator() {
        XCTAssertEqual(
            Array(tree.makeIterator()),
            [
                "beverage",
                "hot",
                "tea",
                "black",
                "green",
                "chai",
                "coffee",
                "cocoa",
                "cold",
                "soda",
                "ginger ale",
                "bitter lemon",
                "milk"
            ]
        )
    }
}
