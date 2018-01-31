// 
// UIView+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

public extension UIView {

    func constraint(_ subviews: [UIView], equallyAlong axis: UILayoutConstraintAxis, spacing: CGFloat = 0) {
        var axisFormat: String = "\(axis.initial):|"
        var dictionaryViews: [String: UIView] = [:]

        for (index, subview) in subviews.enumerated() {
            let key = "subview\(index)"
            dictionaryViews[key] = subview

            if index == 0 {
                axisFormat += "[" + key + "]"
            } else if spacing == 0 {
                axisFormat += "[" + key + "(==subview0)" + "]"
            } else {
                axisFormat += "-\(spacing)-[" + key + "(==subview0)" + "]"
            }
        }

        axisFormat += "|"

        switch axis {
        case .horizontal:
            NSLayoutConstraint.constraints(
                withVisualFormat: axisFormat,
                options: [.alignAllTop, .alignAllBottom],
                metrics: nil,
                views: dictionaryViews
            ).activate()
        case .vertical:
            NSLayoutConstraint.constraints(
                withVisualFormat: axisFormat,
                options: [.alignAllLeft, .alignAllRight],
                metrics: nil,
                views: dictionaryViews
            ).activate()
        }
    }
}

fileprivate extension UILayoutConstraintAxis {

    var initial: Character {
        switch self {
        case .horizontal: return "H"
        case .vertical: return "V"
        }
    }
}
