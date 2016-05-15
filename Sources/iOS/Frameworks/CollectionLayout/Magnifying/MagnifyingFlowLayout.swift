//
//  MagnifyingFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  
//

public class MagnifyingFlowLayout: SnappingFlowLayout {

    // MARK: Property

    public var magnifyingConfig = MagnifyingLayoutConfig()

    // MARK: System Methods

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElementsInRect(rect)?.map {
            $0.representedElementCategory == .Cell ? (self.layoutAttributesForItemAtIndexPath($0.indexPath) ?? $0) : $0
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItemAtIndexPath(indexPath)?.then {
            guard let contentOffset = self.collectionView?.contentOffset else { return }

            let center = $0.center.shiftToCoordinate(contentOffset)
            let scale = magnifyingConfig.scaleAttributesAt(center)

            $0.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
}