//
//  CollectionType+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/16/16.
//  
//

public extension CollectionType where Index.Distance == Int {

    private var randomDistance: Index.Distance {
        return Int(arc4random_uniform(UInt32(self.count)))
    }

    public var randomElement: Generator.Element? {
        guard !self.isEmpty else { return nil }
        return self[self.startIndex.advancedBy(randomDistance)]
    }

    public var randomSlice: SubSequence {
        let startDistance = Int(arc4random_uniform(UInt32(self.count)))
        let startIndex = self.startIndex.advancedBy(startDistance)

        let endDistance = (startDistance..<self.count).randomElement ?? startDistance
        let endIndex = self.startIndex.advancedBy(endDistance)

        return self[startIndex..<endIndex]
    }
}