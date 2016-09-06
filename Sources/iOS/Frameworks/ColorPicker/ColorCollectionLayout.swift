/*
 * ColorCollectionLayout.swift
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

public class ColorCollectionLayout: UICollectionViewFlowLayout {

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init() {
        super.init()
        super.itemSize.width = 30
        super.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        super.scrollDirection = .Horizontal
    }

    // MARK: System Methods

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elements: [UICollectionViewLayoutAttributes] = []

        for attributes in super.layoutAttributesForElementsInRect(rect) ?? [] {
            switch attributes.representedElementCategory {
            case .Cell:
                elements += [self.layoutAttributesForItemAtIndexPath(attributes.indexPath)].flatMap { $0 }
            default:
                elements += [attributes]
            }
        }

        return elements
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
            else { return nil }
        guard hasItemSelected(at: indexPath.item) else { return attributes }
        let cell = self.collectionView?.cellForItemAtIndexPath(indexPath)

        let padding: CGFloat = 25

        let outOfBounds = self.collectionView?.andThen {
            let low = attributes.center.x < $0.contentOffset.x + padding
            let high = attributes.center.x > $0.contentOffset.x + $0.bounds.width - padding
            return low || high
            } ?? false

        guard outOfBounds else {
            cell?.backgroundView = nil
            return attributes
        }

        attributes.center.x = self.collectionView?.andThen { max(attributes.center.x, $0.contentOffset.x + padding) } ?? 0
        attributes.center.x = self.collectionView?.andThen { min(attributes.center.x, $0.contentOffset.x + $0.bounds.width - padding) } ?? 0
        attributes.bounds.size.width = 2 * padding
        attributes.zIndex = 6

        cell?.backgroundView = (self.collectionView as? ColorPickerView)?.pinnedCellBackgroundView

        return attributes
    }
}

extension ColorCollectionLayout {

    func hasItemSelected(at index: Int) -> Bool {
        guard let collectionView = self.collectionView as? ColorPickerView else { return false }

        return collectionView.cellModels[index].state == ColorCollectionCell.Model.State.Selected
    }
}