//
//  MagnifyRootLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/5/16.
//  
//

/*
 * Starting point for subclassing with magnifying behavior.
 */
public class MagnifyRootLayout: SnapRootLayout {

    // MARK: Property

    public var attributes: [NSIndexPath: UICollectionViewLayoutAttributes] = [:]

    public var magnifyConfig: MagnifyLayoutConfig? {
        didSet {
            self.collectionView?.performBatchUpdates({
                self.invalidateLayout()
                self.collectionView?.then { $0.reloadItemsAtIndexPaths($0.indexPathsForVisibleItems()) }
                }, completion: nil)
        }
    }

    // MARK: System Methods

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
        return attributes[indexPath]?.then {
            guard let magnifyConfig = self.magnifyConfig, contentOffset = self.collectionView?.contentOffset else { return }
            let center = contentOffset.convertPointToCoordinate($0.center)
            let scale = magnifyConfig.scaleFor(center)
            $0.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }

}
