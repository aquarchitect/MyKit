//
// AppleWatchHomeScreenLayout.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

final class AppleWatchHomeScreenLayout: ParaboloidSuperLayout {

    private class Attributes: ParaboloidLayoutAttributes {

        override var paraboloidValue: CGFloat? {
            didSet {
                let value = paraboloidValue ?? 1
                self.transform = CGAffineTransform(scaleX: value, y: value)
            }
        }
    }

    static let name = "Apple Watch Home Screen Layout"
    static let items = Array(repeating: 0, count: 400)

    // MARK: Initialization

    class override var layoutAttributesClass: AnyClass {
        return Attributes.self
    }

    private let gridColumn: Int = 20
    private let iterimSpacing: CGFloat = 10

    private let itemSize = CGSize(sideLength: UIScreen.main.traitCollection.displayScale * 50)

    override var collectionViewContentSize: CGSize {
        // add haft of the item size because of shifted odd rows
        let width = CGFloat(gridColumn) * (itemSize.width + iterimSpacing) - iterimSpacing + (itemSize.width / 2)
        let height = ceil(CGFloat(itemsCount) / CGFloat(gridColumn)) * (itemSize.height + iterimSpacing) - iterimSpacing

        return CGSize(width: width, height: height)
    }

    // MARK: Initialization

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()

        self.paraboloidController = ParaboloidLayoutController()
    }


    override func prepare() {
        super.prepare()

        visibleAttributes.removeAll(keepingCapacity: true)

        (0..<itemsCount).forEach {
            let column = $0 % gridColumn
            let row = $0 / gridColumn

            let x = CGFloat(column) * (itemSize.width + iterimSpacing) + CGFloat(row % 2) * itemSize.width / 2
            let y = CGFloat(row) * (itemSize.height + iterimSpacing)

            let origin = CGPoint(x: x, y: y)
            let rect = CGRect(origin: origin, size: itemSize)

            if rect.intersects(self.collectionView?.bounds ?? .zero) {
                let indexPath = IndexPath(arrayLiteral: 0, $0)
                visibleAttributes[indexPath] = Attributes(forCellWith: indexPath)
                    .then({ $0.frame = rect })
            }
        }
    }
}

private extension AppleWatchHomeScreenLayout {

    var itemsCount: Int {
        return (0..<(self.collectionView?.numberOfSections ?? 0)).reduce(0) {
            $0 + (collectionView?.numberOfItems(inSection: $1) ?? 0)
        }
    }
}

extension AppleWatchHomeScreenLayout: LayoutPresentable {}
