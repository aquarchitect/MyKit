//
//  MagnifyLayoutConfig.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/30/16.
//  
//

public struct MagnifyLayoutConfig {

    public typealias Paraboloid = (x: CGFloat, y: CGFloat) -> CGFloat
    public typealias Range = (min: CGFloat, max: CGFloat)

    private let paraboloid: Paraboloid
    public let range: Range?

    public init(paraboloid: Paraboloid, range: Range? = nil) {
        self.paraboloid = paraboloid
        self.range = range
    }

    internal func scaleFor(point: CGPoint) -> CGFloat {
        let z = paraboloid(x: point.x, y: point.y)
        guard let range = self.range else { return z }
        return max(min(z, range.max), range.min)
    }
}