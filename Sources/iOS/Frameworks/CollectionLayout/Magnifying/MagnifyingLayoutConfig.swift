/*
 * MagnifyingLayoutConfig.swift
 *
 * Copyright (c) 2015–2016 Hai Nguyen (http://aquarchitect.github.io)
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

public final class MagnifyingLayoutConfig {

    public typealias Paraboloid = CGPoint -> CGFloat
    public typealias Limits = (min: CGFloat, max: CGFloat)

    // MARK: Property

    public let paraboloid: Paraboloid
    public var scaleLimits: Limits?

    // MARK: Initialization

    public init(paraboloid: Paraboloid, scaleLimits limits: Limits? = nil) {
        self.paraboloid = paraboloid
        self.scaleLimits = limits
    }

    /*
     * Similar to Apple Watch home screen parapoloid function
     */
    public convenience init(bounds: CGRect = UIScreen.mainScreen().bounds) {
        let paraboloid: Paraboloid = {
            let x = -pow(($0.x - bounds.width / 2) / (2.5 * bounds.width), 2)
            let y = -pow(($0.y - bounds.height / 2) / (2.5 * bounds.height), 2)
            return 20 * (x + y) + 1
        }

        self.init(paraboloid: paraboloid)
    }

    // MARK: Support Method

    internal func scaleAttributesAt(point: CGPoint) -> CGFloat {
        if let range = scaleLimits {
            return max(min(paraboloid(point), range.max), range.min)
        } else {
            return max(0, paraboloid(point))
        }
    }
}