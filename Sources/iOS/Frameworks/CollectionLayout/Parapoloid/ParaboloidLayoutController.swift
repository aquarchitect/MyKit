/*
 * ParaboloidLayoutController.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public struct ParaboloidLayoutController {

    public typealias Limits = (min: CGFloat, max: CGFloat)

    // MARK: Property

    private let formula: (CGPoint) -> CGFloat
    public var zValueLimits: Limits?

    // MARK: Initialization

    public init(formula: @escaping (CGPoint) -> CGFloat, zValueLimits limits: Limits? = nil) {
        self.formula = formula
        self.zValueLimits = limits
    }

    /*
     * Similar to Apple Watch home screen parapoloid function
     */
    public init(bounds: CGRect = UIScreen.main.bounds) {
        let formula: (CGPoint) -> CGFloat = {
            let x = -pow(($0.x - bounds.width / 2) / (2.5 * bounds.width), 2)
            let y = -pow(($0.y - bounds.height / 2) / (2.5 * bounds.height), 2)
            return 20 * (x + y) + 1
        }

        self.init(formula: formula)
    }

    // MARK: Support Method

    internal func zValue(atPoint point: CGPoint) -> CGFloat {
        if let range = zValueLimits {
            return fmax(fmin(formula(point), range.max), range.min)
        } else {
            return fmax(0, formula(point))
        }
    }
}
