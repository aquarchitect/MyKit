//
//  CenteredFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/13/16.
//  
//

public class CenteredFlowLayout: UICollectionViewFlowLayout {

    class Attributes: UICollectionViewLayoutAttributes {

        var cornerRadii: CGSize = .zero
        var roundedCorners: UIRectCorner = []
        var showsSeparator = true

        override func copyWithZone(zone: NSZone) -> AnyObject {
            return (super.copyWithZone(zone) as! Attributes)
                .then {
                    $0.cornerRadii = cornerRadii
                    $0.roundedCorners = roundedCorners
                    $0.showsSeparator = true
                }
        }
    }

    public var cornerRadii: CGSize = .zero

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(itemHeight height: CGFloat = 100) {
        super.init()
        super.itemSize.height = height
    }

    public override class func layoutAttributesClass() -> AnyClass {
        return Attributes.self
    }

    public override func prepareLayout() {
        let padding: CGFloat = 15
        let size = UIScreen.mainScreen().bounds.size
        let width = min(size.width, size.height) * (UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 1 : 2/3) - 2 * padding
        let margin = (size.width - width) / 2
        let inset = self.sectionInset

        self.sectionInset = UIEdgeInsetsMake(inset.top, margin, inset.bottom, margin)
        self.itemSize = CGSizeMake(width, self.itemSize.height)
        self.scrollDirection = .Vertical
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0

        super.prepareLayout()
        guard let collectionView = self.collectionView else { return }

        for section in 0..<collectionView.numberOfSections() {
            let range = 0..<collectionView.numberOfItemsInSection(0)
            
            Set([range.first, range.last].flatMap { $0 }.lazy)
                .map { NSIndexPath(forItem: $0, inSection: section) }.lazy
                .flatMap { super.layoutAttributesForItemAtIndexPath($0) as? Attributes }.lazy
                .forEach {
                    let (corners, bottomed) = attributesForItemAt($0.indexPath)

                    $0.cornerRadii = cornerRadii
                    $0.roundedCorners = corners
                    $0.showsSeparator = bottomed
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

extension CenteredFlowLayout.Attributes {

    var maskPath: UIBezierPath {
        return UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundedCorners, cornerRadii: cornerRadii)
    }
}