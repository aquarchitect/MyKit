//
//  CenterPagedLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  
//

public class CenterPagedLayout: UICollectionViewFlowLayout {

    private struct Snapper {

        var trackedIndexPath: NSIndexPath?
        var proposedIndexPath: NSIndexPath?

        let position: CGPoint
        let config: (UICollectionViewLayoutAttributes -> Void)?

        init(position: CGPoint, config: (UICollectionViewLayoutAttributes -> Void)?) {
            self.position = position
            self.config = config
        }

        func distanceFrom(point: CGPoint) -> UICollectionViewLayoutAttributes -> CGFloat {
            let point = CGPointMake(point.x + position.x, point.y + position.y)
            return { CGPointDistanceFrom(fromPoint: $0.center, toPoint: point) }
        }
    }

    private var snapper: Snapper

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(position: CGPoint, config: (UICollectionViewLayoutAttributes -> Void)?) {
        self.snapper = Snapper(position: position, config: config)
        super.init()
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originals = super.layoutAttributesForElementsInRect(rect) else { return nil }
        var elements = [UICollectionViewLayoutAttributes]()

        if snapper.trackedIndexPath == nil {
            var candidate: UICollectionViewLayoutAttributes?
            let distance = snapper.distanceFrom(self.collectionView!.contentOffset)

            for attributes in originals {
                var replacement = attributes

                if case .Cell = attributes.representedElementCategory {
                    if candidate == nil || distance(attributes) < distance(candidate!) { candidate = attributes }
                    replacement = self.layoutAttributesForItemAtIndexPath(attributes.indexPath) ?? replacement
                }

                elements.append(replacement)
            }

            snapper.trackedIndexPath = candidate?.indexPath
        } else {
            elements = originals.map { $0.representedElementCategory == .Cell ? (self.layoutAttributesForItemAtIndexPath($0.indexPath) ??  $0) : $0 }
        }

        return elements
    }

    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let size = self.collectionView!.bounds.size
        let rect = CGRect(origin: proposedContentOffset, size: size)

        guard let elements = self.layoutAttributesForElementsInRect(rect) else { return proposedContentOffset }
        let distance = snapper.distanceFrom(proposedContentOffset)
        let check = { distance($0) < distance($1) }

        if let attributes = (elements.filter { $0.representedElementCategory == .Cell }.sort(check).first) {
            snapper.proposedIndexPath = attributes.indexPath
            return CGPointMake(attributes.center.x - snapper.position.x, attributes.center.y - snapper.position.y)
        } else {
            return proposedContentOffset
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContextForBoundsChange(newBounds)

        guard let trackedIndexPath = snapper.trackedIndexPath, proposedIndexPath = snapper.proposedIndexPath,
            var candidateAttributes = self.layoutAttributesForItemAtIndexPath(trackedIndexPath) else { return context }
        let distance = snapper.distanceFrom(newBounds.origin)

        var indexPath = snapper.trackedIndexPath
        while indexPath != proposedIndexPath {
            switch indexPath!.compare(proposedIndexPath) {

            case .OrderedAscending: indexPath = self.collectionView!.successorOf(indexPath!)
            case .OrderedDescending: indexPath = self.collectionView!.predecessorOf(indexPath!)
            case .OrderedSame: break
            }

            guard let attributes = self.layoutAttributesForItemAtIndexPath(indexPath!)
                where distance(attributes) < distance(candidateAttributes) else { continue }
            candidateAttributes = attributes
        }

        snapper.trackedIndexPath = candidateAttributes.indexPath
        let array = [trackedIndexPath, snapper.trackedIndexPath].flatMap { $0 }
        context.invalidateItemsAtIndexPaths(array)

        return context
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItemAtIndexPath(indexPath)?.then { attrs in
            indexPath == snapper.trackedIndexPath ? UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath).then { $0.frame = attrs.frame; snapper.config?($0) } : attrs
        }
    }
}