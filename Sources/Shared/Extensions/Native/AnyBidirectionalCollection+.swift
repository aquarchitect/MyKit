//
//  AnyBidirectionalCollection+.swift
//  MyKit
//
//  Created by Hai Nguyen.
//

public extension AnyBidirectionalCollection {
    
    subscript(offset offset: Int) -> Element {
        return self[self.index(self.startIndex, offsetBy: Int64(offset))]
    }
}
