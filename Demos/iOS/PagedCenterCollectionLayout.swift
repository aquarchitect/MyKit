/*
 * PagedCenterCollectionLayout.swift
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

final class PagedCenterCollectionLayout: ParaboloidFlowLayout {

    private class Attributes: ParaboloidLayoutAttributes {

        override var paraboloidValue: CGFloat? {
            didSet {
                let value = paraboloidValue ?? 1

                self.zIndex = value > 1.3 ? 2 : 1
                self.transform = CGAffineTransformMakeScale(value, value)
            }
        }
    }

    static let name = "Paged Center Collection Layout"
    static let items = [Array(count: 20, repeatedValue: 0)]

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        let screen = UIScreen.mainScreen()
        let length = screen.traitCollection.displayScale * 50

        super.init()
        super.itemSize = CGSizeMake(length, length)
        super.minimumLineSpacing = 40
        super.minimumInteritemSpacing = 40
        super.scrollDirection = .Horizontal

        let formula: CGPoint -> CGFloat = {
            let x = -pow(($0.x - screen.bounds.width / 2) / (2.5 * screen.bounds.width), 2)
            let y = -pow(($0.y - screen.bounds.height / 2) / (2.5 * screen.bounds.height), 2)
            return 20 * (x + y) + 1.5
        }

        paraboloidFormula = ParaboloidLayoutFormula(formula: formula, zValueLimits: (1, 1.5))
        snappingPoint = screen.bounds.center
    }

    override func prepareLayout() {
        let size = UIScreen.mainScreen().bounds
        let height = size.height - (self.collectionView?.contentInset.vertical ?? 0)

        let verticalMargin = (height - self.itemSize.height) / 2
        let horizontalMargin = (size.width - self.itemSize.width) / 2

        self.sectionInset = UIEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin)

        super.prepareLayout()
    }

    override class func layoutAttributesClass() -> AnyClass {
        return Attributes.self
    }

    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        print(proposedContentOffset)
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }
}

extension PagedCenterCollectionLayout: LayoutPresentable {}