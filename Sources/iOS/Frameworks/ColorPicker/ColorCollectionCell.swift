/*
 * ColorCollectionCell.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
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

import UIKit

public class ColorCollectionCell: UICollectionViewCell {

    public typealias Item = (hexUInt: UInt, enabled: Bool)

    // MARK: Properties

    public override var selected: Bool {
        didSet {
            textLabel.hidden = !selected

            /*
             * textLabel has captured the solid color to display.
             */
            let color = textLabel.textColor
            let alpha: CGFloat = selected ? 0.2 : 1
            self.contentView.backgroundColor = color.colorWithAlphaComponent(alpha)
        }
    }

    private let textLabel = UILabel().then {
        $0.hidden = true
        $0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        $0.backgroundColor = .clearColor()
        $0.attributedText = SymbolIcon("\u{F122}")
            .attributedStringOf(size: 22)
            .then { $0.addAlignment(.Center) }
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.contentView.clipsToBounds = true

        textLabel.frame = self.contentView.bounds
        self.contentView.addSubview(textLabel)
    }

    // MARK: System Methods

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.then {
            let size = self.bounds.size
            let length: CGFloat = min(size.width, size.height, 30)

            $0.frame = CGRect(center: self.bounds.center, sideLength: length)
            $0.layer.cornerRadius = length/2
        }
    }
}

// MARK: - Animation Methods

public extension ColorCollectionCell {

    func animateStateChanged() {
        let color = textLabel.textColor

        textLabel.then {
            $0.hidden = false
            $0.transform = self.selected ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformIdentity
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.contentView.layer.backgroundColor = {
            let alpha: CGFloat = self.selected ? 1 : 0.2
            return color.colorWithAlphaComponent(alpha).CGColor
        }()
        CATransaction.commit()

        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations: {
            self.textLabel.transform = self.selected ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0, 0)

            self.contentView.layer.backgroundColor = {
                let alpha: CGFloat = self.selected ? 0.2 : 1
                return color.colorWithAlphaComponent(alpha).CGColor
            }()
            }, completion: { [weak textLabel] _ in
                textLabel?.hidden = !self.selected
            })
    }
}

// MARK: - Support Methods

extension ColorCollectionCell {

    func render(item: Item) {
        textLabel.textColor = UIColor(hexUInt: item.hexUInt)

        self.contentView.layer.backgroundColor = {
            let alpha: CGFloat = item.enabled ? 1 : 0.2
            return UIColor(hexUInt: item.hexUInt).colorWithAlphaComponent(alpha).CGColor
        }()
    }
}