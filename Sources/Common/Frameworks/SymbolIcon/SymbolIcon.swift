/*
 * SymbolIcon.swift
 * MyKit
 *
 * Copyright (c) 2015–2016 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct SymbolIcon {

    private let character: Character

    public init(character: Character) {
        self.character = character
    }
}

public extension SymbolIcon {

    func attributedStringOf(size: CGFloat) -> NSMutableAttributedString {
        let name = "Ionicons", file = "SymbolIcon"
        return NSMutableAttributedString(string: "\(character)")
            .then { $0.addFont(.fontWith(name: name, size: size, fromFile: file)) }
    }

#if os(iOS)
    func bitmapImageOf(size: CGFloat) -> UIImage? {
        let label = UILabel.dummyInstance.then {
            let string = attributedStringOf(size)
            $0.attributedText = string
            $0.sizeToFit()
        }

        return renderInContext(label.bounds.size, opaque: false, render: label.layer.renderInContext)
    }
#endif
}