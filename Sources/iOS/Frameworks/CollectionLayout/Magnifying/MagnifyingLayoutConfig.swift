//
//  MagnifyingLayoutConfig.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/30/16.
//  
//

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