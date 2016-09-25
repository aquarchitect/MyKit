/*
 * ParaboloidLayoutController.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
