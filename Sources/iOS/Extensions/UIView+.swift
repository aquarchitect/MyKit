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

public extension UIView {

    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) -> Promise<Bool> {
        return Promise { callback in
            self.animate(withDuration: duration, animations: animations) { callback(.fullfill($0)) }
        }
    }
}

public extension UIView {

    enum Axis { case x, y }

    func constraints(subviews: [UIView], equallyAlong axis: Axis) {
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
}

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
