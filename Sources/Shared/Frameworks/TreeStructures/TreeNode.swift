//
// TreeNode.swift
// MyKit
//
// Created by Hai Nguyen on 7/26/17.
// Copyright (c) 2017 Hai Nguyen.
//

final public class TreeNode<T> {

    // MARK: Properties

    public var value: T

    public fileprivate(set) var children: [TreeNode<T>] = []
    public fileprivate(set) weak var parent: TreeNode<T>? = nil

    // MARK: Initialization

    public init(value: T) {
        self.value = value
    }
}

public extension TreeNode {

    /// Start from top to bottom and left to right
    func makeIterator() -> AnyIterator<T> {
        var stack: [IndexingIterator<[TreeNode<T>]>] = []
        var current = [self].makeIterator()

        return AnyIterator<T> {
            while true {
                if let next = current.next() {
                    stack.append(current)
                    current = next.children.makeIterator()
                    return next.value
                } else if let iterator = stack.popLast() {
                    current = iterator
                } else {
                    return nil
                }
            }
        }
    }

    func addChild(_ treeNode: TreeNode) {
        children.append(treeNode)
        treeNode.parent = self
    }

    /// Start from top to bottom and left to right
    func find(`where` predicate: (T) -> Bool) -> TreeNode<T>? {
        guard !predicate(value) else { return self }

        for child in children {
            if let foundChild = child.find(where: predicate) {
                return foundChild
            } else {
                continue
            }
        }

        return nil
    }
}

extension TreeNode: Then {}
