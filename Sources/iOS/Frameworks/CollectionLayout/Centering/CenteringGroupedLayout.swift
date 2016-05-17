//
//  CenteringGroupedLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 5/15/16.
//  
//

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