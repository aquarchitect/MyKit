//
// PagedCenterCollectionLayout.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

final class PagedCenterCollectionLayout: ParaboloidFlowLayout {

    private class Attributes: ParaboloidLayoutAttributes {

        override var paraboloidValue: CGFloat? {
            didSet {
                let value = paraboloidValue ?? 1

                self.zIndex = value > 1.3 ? 2 : 1
                self.transform = CGAffineTransform(scaleX: value, y: value)
            }
        }
    }

    static let name = "Paged Center Collection Layout"
    static let items = Array(repeating: 0, count: 20)

    override class var layoutAttributesClass: AnyClass {
        return Attributes.self
    }

    // MARK: Initialization

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        super.itemSize = CGSize(sideLength: UIScreen.main.scale * 50)
        super.minimumLineSpacing = 40
        super.minimumInteritemSpacing = 40
        super.scrollDirection = .horizontal

        let formula: (CGPoint) -> CGFloat = {
            let size = UIScreen.main.bounds.size

            let x = -pow(($0.x - size.width / 2) / (2.5 * size.width), 2)
            let y = -pow(($0.y - size.height / 2) / (2.5 * size.height), 2)
            return 20 * (x + y) + 1.5
        }

        paraboloidControler = ParaboloidLayoutController(formula: formula, zValueLimits: (1, 1.5))
        snappingPoint = UIScreen.main.bounds.center
    }

    // MARK: System Methods

    override func prepare() {
        super.prepare()

        let size = UIScreen.main.bounds
        let height = size.height - (self.collectionView?.contentInset.vertical ?? 0)

        let verticalMargin = (height - self.itemSize.height) / 2
        let horizontalMargin = (size.width - self.itemSize.width) / 2

        self.sectionInset = UIEdgeInsetsMake(verticalMargin, horizontalMargin, verticalMargin, horizontalMargin)
    }
}

extension PagedCenterCollectionLayout: LayoutPresentable {}
