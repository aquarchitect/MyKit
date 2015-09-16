//
//  SnapLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

class SnapLayout: UICollectionViewFlowLayout {

    private struct Snap {

        var trackedIndexPath: NSIndexPath?
        var proposedIndexPath: NSIndexPath?

        let position: CGPoint
        let transform: (UICollectionViewLayoutAttributes -> Void)?

        init(position: CGPoint, handle: (UICollectionViewLayoutAttributes -> Void)?) {
            self.position = position
            self.transform = handle
        }

        func distance(anchor: CGPoint) -> UICollectionViewLayoutAttributes -> CGFloat {
            let point = CGPointMake(anchor.x + position.x, anchor.y + position.y)
            return { CGPointDistanceFrom(fromPoint: $0.center, toPoint: point) }
        }
    }

    private var snap: Snap

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(position: CGPoint, configure: (UICollectionViewLayoutAttributes -> Void)?) {
        self.snap = Snap(position: position, handle: configure)
        super.init()
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originals = super.layoutAttributesForElementsInRect(rect) else { return nil }
        var elements = [UICollectionViewLayoutAttributes]()

        if snap.trackedIndexPath == nil {
            var candidate: UICollectionViewLayoutAttributes?
            let distance = snap.distance(self.collectionView!.contentOffset)

            for attributes in originals {
                var replacement = attributes

                if case .Cell = attributes.representedElementCategory {
                    if candidate == nil || distance(attributes) < distance(candidate!) { candidate = attributes }
                    replacement = self.layoutAttributesForItemAtIndexPath(attributes.indexPath) ?? replacement
                }

                elements.append(replacement)
            }

            snap.trackedIndexPath = candidate?.indexPath
        } else { elements = originals.map { $0.representedElementCategory == .Cell ? (self.layoutAttributesForItemAtIndexPath($0.indexPath) ??  $0) : $0 }}

        return elements
    }

    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let size = self.collectionView!.bounds.size
        let rect = CGRect(origin: proposedContentOffset, size: size)

        guard let elements = self.layoutAttributesForElementsInRect(rect) else { return proposedContentOffset }
        let distance = snap.distance(proposedContentOffset)
        let check = { distance($0) < distance($1) }

        if let attributes = (elements.filter { $0.representedElementCategory == .Cell }.sort(check).first) {
            snap.proposedIndexPath = attributes.indexPath
            return CGPointMake(attributes.center.x - snap.position.x, attributes.center.y - snap.position.y)
        } else { return proposedContentOffset }
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContextForBoundsChange(newBounds)

        guard let trackedIndexPath = snap.trackedIndexPath, proposedIndexPath = snap.proposedIndexPath,
            var candidate = self.layoutAttributesForItemAtIndexPath(trackedIndexPath) else { return context }

        let distance = snap.distance(newBounds.origin)

        var indexPath = snap.trackedIndexPath
        while indexPath != proposedIndexPath {
            switch indexPath!.compare(proposedIndexPath) {

            case .OrderedAscending: indexPath = self.collectionView!.forwardIndexPath(indexPath!)
            case .OrderedDescending: indexPath = self.collectionView!.backwardIndexPath(indexPath!)
            case .OrderedSame: break
            }

            guard let attributes = self.layoutAttributesForItemAtIndexPath(indexPath!)
                where distance(attributes) < distance(candidate) else { continue }
            candidate = attributes
        }

        snap.trackedIndexPath = candidate.indexPath
        let array = [trackedIndexPath, snap.trackedIndexPath].flatMap { $0 }
        context.invalidateItemsAtIndexPaths(array)

        return context
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let original = super.layoutAttributesForItemAtIndexPath(indexPath) else { return nil }
        if indexPath == snap.trackedIndexPath {
            let replacement = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            replacement.frame = original.frame
            snap.transform?(replacement)
            
            return replacement
        } else { return original }
    }
}
