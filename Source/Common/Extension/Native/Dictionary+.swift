//
//  Dictionary+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/23/16.
//  
//

public extension Dictionary {

    public init<S: SequenceType where S.Generator.Element == Element>(seq: S) {
        self.init()
        self.merge(seq)
    }

    mutating public func merge<S: SequenceType where S.Generator.Element == Element>(seq: S) {
        seq.forEach { self[$0] = $1 }
    }
}