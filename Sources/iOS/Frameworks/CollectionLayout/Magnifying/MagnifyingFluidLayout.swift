/*
 * MagnifyingFluidLayout.swift
 *
 * Copyright (c) 2015–2016 Hai Nguyen (http://aquarchitect.github.io)
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

public class MagnifyingFluidLayout: SnappingSuperLayout {

    // MARK: Property

    public var itemSize = CGSizeMake(50, 50)
    public var gridColumn: Int = 20
    public var iterimSpacing: CGFloat = 10

    public var magnifyingConfig = MagnifyingLayoutConfig()
    public var visibleAttributes: [NSIndexPath: UICollectionViewLayoutAttributes] = [:]

    private var itemsCount: Int {
        return (0..<(collectionView?.numberOfSections() ?? 0)).reduce(0) { $0 + (collectionView?.numberOfItemsInSection($1) ?? 0) }
    }

    // MARK: System Method

    public override func prepareLayout() {
        visibleAttributes.removeAll(keepCapacity: true)

        (0..<itemsCount).forEach {
            let column = $0 % gridColumn
            let row = $0 / gridColumn

            let x = CGFloat(column) * (itemSize.width + iterimSpacing) + CGFloat(row % 2) * itemSize.width / 2
            let y = CGFloat(row) * (itemSize.height + iterimSpacing)

            let origin = CGPointMake(x, y)
            let rect = CGRect(origin: origin, size: itemSize)

            !CGRectIntersectsRect(rect, self.collectionView?.bounds ?? .zero) ? () :
                NSIndexPath(forItem: $0, inSection: 0)
                    .then { UICollectionViewLayoutAttributes(forCellWithIndexPath: $0) }
                    .then { $0.frame = rect; visibleAttributes[$0.indexPath] = $0 }
        }
    }

    public override func collectionViewContentSize() -> CGSize {
        // add halft of the item size because of shifted odd rows
        let width = CGFloat(gridColumn) * (itemSize.width + iterimSpacing) - iterimSpacing + (itemSize.width / 2)
        let height = ceil(CGFloat(itemsCount) / CGFloat(gridColumn)) * (itemSize.height + iterimSpacing) - iterimSpacing
        return CGSizeMake(width, height)
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return visibleAttributes.keys.flatMap(self.layoutAttributesForItemAtIndexPath)
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return visibleAttributes[indexPath]?.then {
            guard let contentOffset = self.collectionView?.contentOffset else { return }

            let center = $0.center.shiftToCoordinate(contentOffset)
            let scale = magnifyingConfig.scaleAttributesAt(center)

            $0.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
}