/*
 * UIStackView+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 3/20/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {

    convenience init(arrangedSubviews: [UIView], columns: Int, rows: Int) {
        assert(arrangedSubviews.count == columns * rows)

        let stackViews: [UIView] = (0 ..< rows).lazy.map {
            Array(arrangedSubviews[($0 * columns) ..< (($0 + 1) * columns)])
            }.map {
                UIStackView(arrangedSubviews: $0).then {
                    $0.alignment = .fill
                    $0.axis = .horizontal
                    $0.distribution = .fillEqually
                    $0.spacing = 1
                }
        }

        self.init(arrangedSubviews: stackViews)
        self.alignment = .fill
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 1
    }
}
