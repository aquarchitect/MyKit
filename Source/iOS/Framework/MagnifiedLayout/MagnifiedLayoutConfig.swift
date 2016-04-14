//
//  MagnifiedLayoutConfig.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/30/16.
//  
//

public final class MagnifiedLayoutConfig {

    public typealias Paraboloid = (x: CGFloat, y: CGFloat) -> CGFloat
    public typealias Range = (min: CGFloat, max: CGFloat)

    // MARK: Property

    private let paraboloid: Paraboloid

    // MARK: Initialization

    public init(paraboloid: Paraboloid) {
        self.paraboloid = paraboloid
    }

    /*
     * Similar to Apple Watch home screen parapoloid function
     */
    public convenience init(bounds: CGRect = UIScreen.mainScreen().bounds) {
        let paraboloid: Paraboloid = {
            let x = -pow(($0 - bounds.width / 2) / (2.5 * bounds.width), 2)
            let y = -pow(($1 - bounds.height / 2) / (2.5 * bounds.height), 2)
            return 20 * (x + y) + 1
        }

        self.init(paraboloid: paraboloid)
    }

    // MARK: Support Method

    internal func scaleAttributesAt(point: CGPoint) -> CGFloat {
        return max(0, paraboloid(x: point.x, y: point.y))
    }
}

extension MagnifiedLayoutConfig: Then {}