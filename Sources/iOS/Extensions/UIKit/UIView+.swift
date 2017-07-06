// 
// UIView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

public extension UIView {

    typealias AnimatingCompletion = (Bool) -> Void
}

extension UIView {

    func customSnapshotView() -> UIView? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)

        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
}

public extension UIView {

    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) -> Observable<Bool> {
        return Observable().then {
            self.animate(
                withDuration: duration,
                animations: animations,
                completion: $0.update
            )
        }
    }
}

public extension UIView {

    func constraint(_ subviews: [UIView], equallyAlong axis: UILayoutConstraintAxis) {
        var axisFormat: String = "\(axis.initial):|"
        var dictionaryViews: [String: UIView] = [:]
        var oppositeFormat: [String] = []

        for (index, subview) in subviews.enumerated() {
            let key = "subview\(index)"
            dictionaryViews[key] = subview

            oppositeFormat.append("\(axis.opposite.initial):|[\(key)]|")
            axisFormat += "[" + key + (index == 0 ? "" : "(==subview0)") + "]"
        }

        axisFormat += "|"

        (oppositeFormat + [axisFormat]).reduce([]) {
            $0 + NSLayoutConstraint.constraints(
                withVisualFormat: $1,
                metrics: nil,
                views: dictionaryViews
            )
        }.activate()
    }
}

fileprivate extension UILayoutConstraintAxis {

    var initial: Character {
        switch self {
        case .horizontal: return "H"
        case .vertical: return "V"
        }
    }

    var opposite: UILayoutConstraintAxis {
        switch self {
        case .horizontal: return .vertical
        case .vertical: return .horizontal
        }
    }
}
