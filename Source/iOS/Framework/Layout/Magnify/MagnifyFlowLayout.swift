//
//  MagnifyFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  
//

public class MagnifyFlowLayout: SnapFlowLayout {

    // MARK: Property

    public var magnifyConfig: MagnifyLayoutConfig? {
        didSet {
            self.collectionView?.performBatchUpdates({
                self.invalidateLayout()
                self.collectionView?.then { $0.reloadItemsAtIndexPaths($0.indexPathsForVisibleItems()) }
            }, completion: nil)
        }
    }

    // MARK: System Methods

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElementsInRect(rect)?.map {
            $0.representedElementCategory == .Cell ? (self.layoutAttributesForItemAtIndexPath($0.indexPath) ?? $0) : $0
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContextForBoundsChange(newBounds)
        guard let _ = self.magnifyConfig else { return context }

        return super.invalidationContextForBoundsChange(newBounds).then {
            magnifyConfig != nil ? $0.invalidateItemsAtIndexPaths(self.collectionView?.indexPathsForVisibleItems() ?? []) : ()
        }
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItemAtIndexPath(indexPath)?.then {
            guard let magnifyConfig = self.magnifyConfig, contentOffset = self.collectionView?.contentOffset else { return }
            let center = contentOffset.convertPointToCoordinate($0.center)
            let scale = magnifyConfig.scaleFor(center)
            $0.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
}