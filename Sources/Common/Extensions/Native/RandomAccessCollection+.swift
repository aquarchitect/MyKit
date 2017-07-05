//
// RandomAccessCollection+.swift
// MyKit
//
// Created by Hai Nguyen.
// Copyright (c) 2017 Hai Nguyen.
//

extension RandomAccessCollection {

    func element(at index: Index) -> Iterator.Element? {
        let distance = self.distance(from: self.startIndex, to: index)

        return self.index(
            self.startIndex,
            offsetBy: distance,
            limitedBy: self.endIndex
        ).map { self[$0] }
    }
}
