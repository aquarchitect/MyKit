/*
 * RangeReplaceableCollectionType+.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation

public extension RangeReplaceableCollectionType where Index == Int {

    mutating func apply(changes: [Change<(index: Index, element: Generator.Element)>]) {
        for change in changes {
            switch change {
            case .Delete(let step): self.removeAtIndex(step.index)
            case .Insert(let step): self.insert(step.element, atIndex: step.index)
            }
        }
    }

    @warn_unused_result
    func applying(changes: [Change<(index: Index, element: Generator.Element)>]) -> Self {
        var result = self
        result.apply(changes)
        return result
    }

    mutating func apply(changes: [Change<(index: Index, element: Generator.Element)>], inSection section: Int) -> (deletes: [NSIndexPath], inserts: [NSIndexPath]) {
        let indexPathMapper = { NSIndexPath(indexes: section, $0) }
        var deletes: [NSIndexPath] = [], inserts: [NSIndexPath] = []

        for change in changes {
            switch change {
            case .Delete(let step):
                self.removeAtIndex(step.index)
                deletes += [step.index].map(indexPathMapper)
            case .Insert(let step):
                self.insert(step.element, atIndex: step.index)
                inserts += [step.index].map(indexPathMapper)
            }
        }

        return (deletes, inserts)
    }
}