//
//  AnyRandomAccessCollection+.swift
//  MyKit
//
//  Created by Hai Nguyen.
//

public extension AnyRandomAccessCollection {
    
    subscript(offset offset: Int) -> Element {
        return self[self.index(self.startIndex, offsetBy: Int64(offset))]
    }
}
