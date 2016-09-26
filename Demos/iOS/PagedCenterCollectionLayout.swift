/*
 * PagedCenterCollectionLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
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
    static let items = Array(count: 20, repeatedValue: 0)

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
