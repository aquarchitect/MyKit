//
//  Dictionary+.swift
//  MyKit
//
//  Created by Hai Nguyen on 8/20/15.
//
//

public extension Dictionary {

    public init<T: SequenceType where T.Generator.Element == Element>(dictionaryLiteral elements: T) {
        self.init()

        
        elements.reduce(self) { (var dict, elem) in
            dict[elem.0] = elem.1
            return dict
        }
    }
}