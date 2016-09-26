/*
 * ParaboloidLayoutAttributes.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

public class ParaboloidLayoutAttributes: UICollectionViewLayoutAttributes {

    public var paraboloidValue: CGFloat?

    public override func copy(with zone: NSZone? = nil) -> Any {
        let attributes = super.copy(with: zone)

        return (attributes as? ParaboloidLayoutAttributes)?
            .then { $0.paraboloidValue = paraboloidValue }
            ?? attributes
    }
}
