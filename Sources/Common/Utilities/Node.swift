/*
 * Node.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

open class Node<T> {

    public let value: T

    open weak fileprivate(set) var parent: Node?
    fileprivate(set) var children: [Node] = []

    public init(_ value: T) {
        self.value = value
    }

    public subscript(index: Int) -> Node {
        return children[index]
    }

    public func add(child: Node) {
        children.append(child)
        child.parent = self
    }
}

public extension Node {

    var lastChild: Node? {
        return children.last
    }

    var lastNode: Node? {
        var node = self

        while let _node = node.lastChild {
            node = _node
        }

        return node
    }
}

public extension Node where T: Equatable {

    func search(_ value: T) -> Node? {
        guard value == self.value else { return self }

        var node: Node?
        for child in children {
            node = child.search(value)
            if node != nil { break }
        }

        return node
    }
}

extension Node: CustomStringConvertible {

    public var description: String {
        let text = "\(value)"
        guard !children.isEmpty else { return text }

        return text
            + " {"
            + children
                .map { $0.description }
                .joined(separator: ", ")
            + "}"
    }
}
