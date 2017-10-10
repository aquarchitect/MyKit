//
//  AnyCollection+.swift
//  MyKit
//
//  Created by Hai Nguyen.
//

public extension AnyCollection {
    
    subscript(offset offset: Int) -> Element {
        return self[self.index(self.startIndex, offsetBy: Int64(offset))]
    }
}
