// 
// ParaboloidLayoutAttributes.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

open class ParaboloidLayoutAttributes: UICollectionViewLayoutAttributes {

    open var paraboloidValue: CGFloat?

    open override func copy(with zone: NSZone? = nil) -> Any {
        let attributes = super.copy(with: zone)

        return (attributes as? ParaboloidLayoutAttributes)?
            .then { $0.paraboloidValue = paraboloidValue }
            ?? attributes
    }
}
