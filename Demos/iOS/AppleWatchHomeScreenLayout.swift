/*
 * AppleWatchHomeScreenLayout.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

final class AppleWatchHomeScreenLayout: ParaboloidSuperLayout {

    private class Attributes: ParaboloidLayoutAttributes {

        override var paraboloidValue: CGFloat? {
            didSet {
                let value = paraboloidValue ?? 1
                self.transform = CGAffineTransformMakeScale(value, value)
            }
        }
    }

    static let name = "Apple Watch Home Screen Layout"
    static let items = Array(count: 400, repeatedValue: 0)

    private var gridColumn: Int = 20
    private var iterimSpacing: CGFloat = 10

    private var itemSize: CGSize = {
        let length = UIScreen.mainScreen().traitCollection.displayScale * 50
        return CGSizeMake(length, length)
    }()

    private var itemsCount: Int {
        return (0..<(collectionView?.numberOfSections() ?? 0)).reduce(0) { $0 + (collectionView?.numberOfItemsInSection($1) ?? 0) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()

        self.paraboloidFormula = ParaboloidLayoutFormula()
    }

    class override func layoutAttributesClass() -> AnyClass {
        return Attributes.self
    }

    override func prepareLayout() {
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
                    .then { Attributes(forCellWithIndexPath: $0) }
                    .then { $0.frame = rect; visibleAttributes[$0.indexPath] = $0 }
        }
    }

    override func collectionViewContentSize() -> CGSize {
        // add halft of the item size because of shifted odd rows
        let width = CGFloat(gridColumn) * (itemSize.width + iterimSpacing) - iterimSpacing + (itemSize.width / 2)
        let height = ceil(CGFloat(itemsCount) / CGFloat(gridColumn)) * (itemSize.height + iterimSpacing) - iterimSpacing
        return CGSizeMake(width, height)
    }
}

extension AppleWatchHomeScreenLayout: LayoutPresentable {}
