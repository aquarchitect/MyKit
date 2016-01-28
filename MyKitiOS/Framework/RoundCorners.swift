//
//  RoundCorners.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/25/16.
//
//

public protocol RoundCorners: class {

    var roundedCorners: (corners: UIRectCorner, radius: CGFloat) { get set }
}

public extension RoundCorners {

    func roundCornersView(view: UIView) {
        let size = CGSize(sideLength: roundedCorners.radius)

        view.clipsToBounds = true
        view.layer.mask = CAShapeLayer().setup {
            $0.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: roundedCorners.corners, cornerRadii: size).CGPath
        }
    }
}