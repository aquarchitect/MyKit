/*
 * CenteringGroupedLayout.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
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

public class CenteringGroupedLayout: CenteringFlowLayout {

    class Attributes: UICollectionViewLayoutAttributes {

        var cornerRadii: CGSize = .zero
        var roundedCorners: UIRectCorner = []
        var showsSeparator = true

        override func copyWithZone(zone: NSZone) -> AnyObject {
            return (super.copyWithZone(zone) as! Attributes).then {
                $0.cornerRadii = cornerRadii
                $0.roundedCorners = roundedCorners
                $0.showsSeparator = showsSeparator
            }
        }
    }

    public var cornerRadii = CGSizeMake(5, 5)

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init() {
        super.init()
        super.minimumLineSpacing = 0
        super.minimumInteritemSpacing = 0
    }

    public override class func layoutAttributesClass() -> AnyClass {
        return Attributes.self
    }

    public override func prepareLayout() {
        super.prepareLayout()

        for section in 0..<(self.collectionView?.numberOfSections() ?? 0) {
            let range = 0..<(self.collectionView?.numberOfItemsInSection(section) ?? 0)

            Set([range.first, range.last].flatMap { $0 }.lazy)
                .map { NSIndexPath(forItem: $0, inSection: section) }.lazy
                .flatMap { super.layoutAttributesForItemAtIndexPath($0) as? Attributes }.lazy
                .forEach {
                    let (corners, bottomed) = attributesForItemAt($0.indexPath)

                    $0.cornerRadii = cornerRadii
                    $0.roundedCorners = corners
                    $0.showsSeparator = !bottomed
            }
        }
    }

    private func attributesForItemAt(indexPath: NSIndexPath) -> (corners: UIRectCorner, bottomed: Bool) {
        switch self.collectionView?.numberOfItemsInSection(indexPath.section) {
        case 1?: return (.AllCorners, true)
        case (indexPath.item + 1)?: return ([.BottomLeft, .BottomRight], true)
        case _ where indexPath.item == 0: return ([.TopLeft, .TopRight], false)
        default: return ([], false)
        }
    }
}

extension CenteringGroupedLayout.Attributes {

    var maskPath: UIBezierPath {
        return UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundedCorners, cornerRadii: cornerRadii)
    }
}