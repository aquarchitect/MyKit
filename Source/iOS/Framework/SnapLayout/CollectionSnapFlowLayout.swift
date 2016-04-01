//
//  CollectionSnapFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  
//

public class CollectionSnapFlowLayout: UICollectionViewFlowLayout {

    // MARK: Property

    public var snappedIndexPath: NSIndexPath? {
        get { return userInfo?.trackedIndexPath }
        set {
            switch newValue {
            case let value?:
                guard let offset = self.collectionView?.contentOffset,
                    var position = super.layoutAttributesForItemAtIndexPath(value)?.center
                    else { fallthrough }

                position = CGPointMake(position.x - offset.x, position.y - offset.y)
                userInfo = CollectionLayoutSnappingUserInfo(indexPath: value, position: position)
            default: userInfo = nil
            }

            self.collectionView?.performBatchUpdates({
                self.collectionView?.then {
                    $0.reloadItemsAtIndexPaths($0.indexPathsForVisibleItems())
                }
                }, completion: nil)
        }
    }

    private var userInfo: CollectionLayoutSnappingUserInfo?
    private let scales: [CGFloat]

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(scales: [CGFloat] = [1.2, 0.9]) {
        self.scales = scales
        super.init()
    }

    // MARK: System Method

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElementsInRect(rect)?.map {
            $0.representedElementCategory == .Cell ? (self.layoutAttributesForItemAtIndexPath($0.indexPath) ?? $0) : $0
        }
    }

    /*
     * Call once before collection view starts scrolling
     * so it's perfectly fine for one loop iteration.
     */
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let userInfo = self.userInfo else { return proposedContentOffset }
        let size = (self.collectionView?.bounds ?? .zero).size
        let rect = CGRect(origin: proposedContentOffset, size: size)

        let distance = userInfo.distanceFrom(proposedContentOffset)

        let attributes = (super.layoutAttributesForElementsInRect(rect) ?? []).filter {
                $0.representedElementCategory == .Cell
            }.sort {
                distance($0) < distance($1)
            }.first

        if let _attributes = attributes {
            userInfo.proposedIndexPath = NSIndexPath(indexes: _attributes.indexPath.indexes)

            let x = _attributes.center.x - userInfo.anchorPosition.x
            let y = _attributes.center.y - userInfo.anchorPosition.y
            return CGPointMake(x, y)
        } else {
            return proposedContentOffset
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    /*
     * Start a loop from current snapped indexPath to
     * a proposed snapped indexPath where scrolling will
     * stop. For optimization, the iteration also filters 
     * the unecessary attributes that are not visible on
     * screen.
     */
    public override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContextForBoundsChange(newBounds)

        guard let userInfo = self.userInfo,
            var candidate = super.layoutAttributesForItemAtIndexPath(userInfo.trackedIndexPath)
            else { return context }

        let distanceTo = userInfo.distanceFrom(newBounds.origin)
        var indexPath = userInfo.trackedIndexPath

        indexing: while userInfo.proposedIndexPath != indexPath {
            switch userInfo.proposedIndexPath.compare(indexPath) {
            case .OrderedDescending: self.collectionView?.successorOf(indexPath)?.then { indexPath = $0 }
            case .OrderedAscending: self.collectionView?.predecessorOf(indexPath)?.then { indexPath = $0 }
            default: break indexing
            }

            super.layoutAttributesForItemAtIndexPath(indexPath)?.then {
                distanceTo($0) < distanceTo(candidate) ? candidate = $0 : ()
            }
        }

        return context.then {
            $0.invalidateItemsAtIndexPaths([userInfo.trackedIndexPath, candidate.indexPath].distint())
            userInfo.trackedIndexPath = candidate.indexPath
        }
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItemAtIndexPath(indexPath)?.then {
            guard let userInfo = self.userInfo else { return }
            let condition = userInfo.trackedIndexPath == indexPath
            let scale = condition ? scales[0] : scales[1]

            $0.transform = CGAffineTransformMakeScale(scale, scale)
            $0.zIndex = condition ? 1 : 0
        }
    }
}