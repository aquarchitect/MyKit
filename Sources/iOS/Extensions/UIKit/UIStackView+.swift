// 
// UIStackView+.swift
// MyKit
// 
// Created by Hai Nguyen on 3/20/17.
// Copyright (c) 2017 Hai Nguyen.
// 

import UIKit

@available(iOS 9.0, *)
public extension UIStackView {

    convenience init(arrangedSubviews: [UIView], columns: Int, rows: Int) {
        assert(arrangedSubviews.count == columns * rows)

        self.init()
        self.alignment = .fill
        self.axis = .vertical
        self.distribution = .fillEqually

        for row in 0 ..< rows {
            let range = (row * columns) ..< ((row + 1) * columns)
            let subviews = Array(arrangedSubviews[range])

            UIStackView(arrangedSubviews: subviews).then {
                $0.alignment = .fill
                $0.axis = .horizontal
                $0.distribution = .equalSpacing
                $0.translatesAutoresizingMaskIntoConstraints = false
            }.then(self.addArrangedSubview)
        }
    }
}
