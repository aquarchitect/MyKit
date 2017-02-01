/*
 * NSAttributedString+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 2/1/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import Foundation

public extension NSAttributedString {

    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        return ((lhs as? NSMutableAttributedString)
            ?? NSMutableAttributedString(attributedString: lhs))
            .then { $0.append(rhs) }
    }
}
