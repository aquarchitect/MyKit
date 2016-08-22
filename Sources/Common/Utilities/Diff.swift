/*
 * Diff.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
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

public struct Diff<T: Equatable> {

    public typealias Step = (Int, T)

    public let deletes: [Step]
    public let inserts: [Step]

    public var isEmpty: Bool {
        return inserts.isEmpty && deletes.isEmpty
    }

    internal init(deletes: [Step] = [], inserts: [Step] = []) {
        self.deletes = deletes
        self.inserts = inserts
    }
}

public extension Diff {

    var updateIndexes: [Int] {
        let deletes = Set(self.deletes.map { $0.0 })
        let inserts = Set(self.inserts.map { $0.0 })
        return deletes.intersect(inserts).sort(<)
    }

    /**
     * Delete indexes excluded updates
     */
    var exclusiveDeleteIndexes: [Int] {
        let updates = Set(updateIndexes)
        return deletes
            .filter { !updates.contains($0.0) }
            .lazy.map { $0.0 }
    }

    /**
     * Insert indexes excluded updates
     */
    var exclusiveInsertIndexes: [Int] {
        let updates = Set(updateIndexes)
        return inserts
            .filter { !updates.contains($0.0) }
            .lazy.map { $0.0 }
    }
}

extension Diff: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Deletes: \(deletes.debugDescription)\nInserts: \(inserts.debugDescription)"
    }
}