//
// BinaryTreeTests.swift
// MyKit
//
// Created by Hai Nguyen on 7/28/17.
// Copyright (c) 2017 Hai Nguyen.
//

import MyKit

final class BinaryTreeTests: XCTestCase {}

extension BinaryTreeTests {

    private var tree: BinaryTree<String> {
        // leaf nodes
        let node5 = BinaryTree.node(.empty, "5", .empty)
        let nodeA = BinaryTree.node(.empty, "a", .empty)
        let node10 = BinaryTree.node(.empty, "10", .empty)
        let node4 = BinaryTree.node(.empty, "4", .empty)
        let node3 = BinaryTree.node(.empty, "3", .empty)
        let nodeB = BinaryTree.node(.empty, "b", .empty)

        // intermediate nodes on the left
        let nodeMinus10 = BinaryTree.node(nodeA, "-", node10)
        let node5TimesMinus10 = BinaryTree.node(node5, "*", nodeMinus10)

        // intermediate nodes on the right
        let nodeMinus4 = BinaryTree.node(.empty, "-", node4)
        let node3DivideB = BinaryTree.node(node3, "/", nodeB)
        let node4TimesDividieB = BinaryTree.node(nodeMinus4, "*", node3DivideB)
        
        // root node
        return .node(node5TimesMinus10, "+", node4TimesDividieB)
    }

    func testIterator() {
        XCTAssertEqual(
            Array(tree.makeInOrderTraversingIterator()),
            ["5", "*", "a", "-", "10", "+", "-", "4", "*", "3", "/", "b"]
        )
    }
}
