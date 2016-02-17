//
//  CollectionType+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/16/16.
//  
//

public extension CollectionType where Index.Distance == Int {

    public var random: Generator.Element? {
        guard !self.isEmpty else { return nil }
        let distance = Int(arc4random_uniform(UInt32(self.count)))
        return self[self.startIndex.advancedBy(distance)]
    }
}