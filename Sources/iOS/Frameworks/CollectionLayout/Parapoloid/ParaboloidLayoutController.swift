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

    private static let AppleWatchHomeScreenFormula: (CGRect, CGPoint) -> CGFloat = {
        let x = -pow(($1.x - $0.width / 2) / (2.5 * $0.width), 2)
        let y = -pow(($1.y - $0.height / 2) / (2.5 * $0.height), 2)
        return 20 * (x + y) + 1
    }

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
        self.init(formula: { ParaboloidLayoutController.AppleWatchHomeScreenFormula(bounds, $0) })
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
