/*
 * UIView+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

public extension UIView {

    typealias AnimatingCompletion = (Bool) -> Void
}

extension UIView {

    func customSnapshotView() -> UIView? {
#if swift(>=3.0)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
#else
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0)
#endif

        if let context = UIGraphicsGetCurrentContext() {
#if swift(>=3.0)
            self.layer.render(in: context)
#else
            self.layer.renderInContext(context)
#endif
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
}

public extension UIView {

#if swift(>=3.0)
    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) -> Promise<Bool> {
        return Promise { callback in
            self.animate(withDuration: duration, animations: animations) {
                callback(.fulfill($0))
            }
        }
    }
#else
    static func animateWithDuration(duration: NSTimeInterval, animations: () -> Void) -> Promise<Bool> {
        return Promise { callback in
            self.animateWithDuration(duration, animations: animations) {
                callback(.fulfill($0))
            }
        }
    }
#endif
}

public extension UIView {

#if swift(>=3.0)
    enum Axis { case x, y }

    func constraint(_ subviews: [UIView], equallyAlong axis: Axis) {
        var axisFormat: String = "\(axis.initial):|"
        var dictionaryViews: [String: UIView] = [:]
        var oppositeFormat: [String] = []

        for (index, subview) in subviews.enumerated() {
            let key = "subview\(index)"
            dictionaryViews[key] = subview

            oppositeFormat += ["\(axis.reversed.initial):|[\(key)]|"]
            axisFormat += "[" + key + (index == 0 ? "" : "(==subview0)") + "]"
        }

        axisFormat += "|"

        (oppositeFormat + [axisFormat])
            .reduce([]) { $0 + NSLayoutConstraint.constraints(withVisualFormat: $1, options: [], metrics: nil, views: dictionaryViews) }
            .activate()
    }
#else
    enum Axis { case X, Y }

    func constraintSubviews(subviews: [UIView], equallyAlong axis: Axis) {
        var axisFormat: String = "\(axis.initial):|"
        var dictionaryViews: [String: UIView] = [:]
        var oppositeFormat: [String] = []

        for (index, subview) in subviews.enumerate() {
            let key = "subview\(index)"
            dictionaryViews[key] = subview

            oppositeFormat += ["\(axis.reversed.initial):|[\(key)]|"]
            axisFormat += "[" + key + (index == 0 ? "" : "(==subview0)") + "]"
        }

        axisFormat += "|"

        (oppositeFormat + [axisFormat])
            .reduce([]) { $0 + NSLayoutConstraint.constraintsWithVisualFormat($1, options: [], metrics: nil, views: dictionaryViews) }
            .activate()
    }
#endif
}

#if swift(>=3.0)
fileprivate extension UIView.Axis {

    var initial: Character {
        switch self {
        case .x: return "H"
        case .y: return "V"
        }
    }

    var reversed: UIView.Axis {
        switch self {
        case .x: return .y
        case .y: return .x
        }
    }
}
#else
private extension UIView.Axis {

    var initial: Character {
        switch self {
        case .X: return "H"
        case .Y: return "V"
        }
    }

    var reversed: UIView.Axis {
        switch self {
        case .X: return .Y
        case .Y: return .X
        }
    }
}
#endif
