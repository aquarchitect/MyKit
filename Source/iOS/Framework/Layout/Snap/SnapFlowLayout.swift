//
//  SnapFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/5/16.
//  
//

/*
 * Reference SnapLayoutConfig.swift
 */
public class SnapFlowLayout: UICollectionViewFlowLayout {

    // MARK: Property

    private var snappedConfig: SnapLayoutConfig?

    public var snappedIndexPath: NSIndexPath? {
        get { return snappedConfig?.indexPath }
        set {
            guard let indexPath = newValue, collectionView = self.collectionView,
                attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
                else { return snappedConfig = nil }
            let position = collectionView.contentOffset.convertPointToCoordinate(attributes.center)
            snappedConfig = SnapLayoutConfig(indexPath: indexPath, anchorPosition: position)
        }
    }

    // MARK: System Method

    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let userInfo = self.snappedConfig,
            collectionView = self.collectionView
            else { return proposedContentOffset }

        let rect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)

        let distance: UICollectionViewLayoutAttributes -> CGFloat = {
            let center = proposedContentOffset.convertPointToCoordinate($0.center)
            return CGPointDistanceToPoint(center, userInfo.anchorPosition)
        }

        return (super.layoutAttributesForElementsInRect(rect) ?? [])
            .filter { $0.representedElementCategory == .Cell }.lazy
            .sort { distance($0) < distance($1) }.lazy.first?
            .andThen {
                userInfo.indexPath = $0.indexPath
                let x = $0.center.x - userInfo.anchorPosition.x
                let y = $0.center.y - userInfo.anchorPosition.y
                return CGPointMake(x, y)
            } ?? proposedContentOffset
    }
}