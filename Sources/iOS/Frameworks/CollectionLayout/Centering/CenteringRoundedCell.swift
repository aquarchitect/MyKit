/*
 * CenteringRoundedCell.swift
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

import UIKit

public class CenteringRoundedCell: UICollectionViewCell {

    private var separatorLayer = CAShapeLayer().then {
        $0.strokeColor = UIColor.lightGrayColor().CGColor
        $0.lineWidth = 0.5
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.then {
            $0.masksToBounds = true
            $0.mask = CAShapeLayer()
            $0.addSublayer(separatorLayer)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        separatorLayer.then {
            let y = self.bounds.maxY - $0.lineWidth / 2
            let points = [self.bounds.minX, self.bounds.maxX].map { CGPointMake($0, y) }

            $0.zPosition = 100
            $0.path = UIBezierPath(points: points).CGPath
        }
    }

    public override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)

        (layoutAttributes as? CenteringGroupedLayout.Attributes)?.then {
            separatorLayer.hidden = !$0.showsSeparator
            (self.layer.mask as? CAShapeLayer)?.path = $0.maskPath.CGPath
        }
    }
}