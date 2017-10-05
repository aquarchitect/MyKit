//
// BinaryTree.swift
// MyKit
//
// Created by Hai Nguyen on 7/25/17.
// Copyright (c) 2017 Hai Nguyen.
//

public indirect enum BinaryTree<T> {

    case node(BinaryTree<T>, T, BinaryTree<T>)
    case empty
}

public extension BinaryTree {

    var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + right.count + 1
        case .empty:
            return 0
        }
    }
}

public extension BinaryTree {

    func traverseInOrder(process: (T) -> Void) {
        guard case let .node(left, value, right) = self else { return }
        left.traverseInOrder(process: process)
        process(value)
        right.traverseInOrder(process: process)
    }

    func traversePreOrder(process: (T) -> Void) {
        guard case let .node(left, value, right) = self else { return }
        process(value)
        left.traversePreOrder(process: process)
        right.traversePreOrder(process: process)
    }

    func traversePostOrder(process: (T) -> Void) {
        guard case let .node(left, value, right) = self else { return }
        left.traversePostOrder(process: process)
        right.traversePostOrder(process: process)
        process(value)
    }
}

public extension BinaryTree {

    func makeInOrderTraversingIterator() -> AnyIterator<T> {
        var stack: [BinaryTree<T>] = []
        var current: BinaryTree<T> = self

        return AnyIterator<T> {
            while true {
                if case let .node(left, _, _) = current {
                    stack.append(current)
                    current = left
                } else if case let .node(_, value, right)? = stack.popLast() {
                    current = right
                    return value
                } else {
                    return nil
                }
            }
        }
    }
}

public extension BinaryTree where T: CustomStringConvertible {

    var description: String {
        return try! JSONSerialization.prettyPrintedDescription(JSONObject: json)
    }

    var json: [String: Any] {
        switch self {
        case let .node(left, value, right):
            return [
                "node": value.description,
                "left":  left.description,
                "right": right.description
            ]
        case .empty:
            return ["node": "empty"]
        }
    }
}

