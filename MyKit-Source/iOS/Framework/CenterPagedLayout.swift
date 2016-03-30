//
//  CenterPagedLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  
//

public class CenterPagedLayout: UICollectionViewFlowLayout {

    public struct Snap {

        private var trackedIndexPath: NSIndexPath?
        private var proposedIndexPath: NSIndexPath?

        public let position: CGPoint

        private init(position: CGPoint) {
            self.position = position
        }
    }

    // MARK: Property

    public var snapping: Snap {
        didSet { self.invalidateLayout() }
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(snappingPosition position: CGPoint) {
        self.snapping = Snap(position: position)
        super.init()
    }

    // MARK: System Method

    public override func prepareLayout() {
        super.prepareLayout()

        self.collectionView?.then {
            switch self.scrollDirection {
            case .Horizontal:
                $0.contentInset.left = snapping.position.x
                $0.contentInset.right = $0.bounds.width - snapping.position.x
            case .Vertical:
                $0.contentInset.top = snapping.position.y
                $0.contentInset.bottom = $0.bounds.height - snapping.position.y
            }
        }
    }

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originals = super.layoutAttributesForElementsInRect(rect) else { return nil }
        var elements = [UICollectionViewLayoutAttributes]()

        if snapping.trackedIndexPath == nil {
            var candidate: UICollectionViewLayoutAttributes?
            let distance = snapping.distanceFrom(self.collectionView!.contentOffset)

            for attributes in originals {
                var replacement = attributes

                if case .Cell = attributes.representedElementCategory {
                    if candidate == nil || distance(attributes) < distance(candidate!) { candidate = attributes }
                    replacement = self.layoutAttributesForItemAtIndexPath(attributes.indexPath) ?? replacement
                }

                elements.append(replacement)
            }

            snapping.trackedIndexPath = candidate?.indexPath
        } else {
            elements = originals.flatMap { $0.representedElementCategory == .Cell ? layoutAttributesForItemAtIndexPath($0.indexPath) : $0 }
        }

        return elements
    }

    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let size = self.collectionView!.bounds.size
        let rect = CGRect(origin: proposedContentOffset, size: size)

        guard let elements = self.layoutAttributesForElementsInRect(rect) else { return proposedContentOffset }
        let distance = snapping.distanceFrom(proposedContentOffset)
        let check = { distance($0) < distance($1) }

        if let attributes = (elements.filter { $0.representedElementCategory == .Cell }.sort(check).first) {
            snapping.proposedIndexPath = attributes.indexPath
            return CGPointMake(attributes.center.x - snapping.position.x, attributes.center.y - snapping.position.y)
        } else {
            return proposedContentOffset
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContextForBoundsChange(newBounds)
        guard let trackedIndexPath = snapping.trackedIndexPath else { return context }
        context.invalidateItemsAtIndexPaths([trackedIndexPath])

        guard let proposedIndexPath = snapping.proposedIndexPath else { return context }
        var candidate = layoutAttributesForItemAtIndexPath(trackedIndexPath)
        let distance = snapping.distanceFrom(newBounds.origin)

        var indexPath = snapping.trackedIndexPath
        while let _indexPath = indexPath where _indexPath != proposedIndexPath {
            switch _indexPath.compare(proposedIndexPath) {
            case .OrderedAscending: indexPath = self.collectionView!.successorOf(_indexPath)
            case .OrderedDescending: indexPath = self.collectionView!.predecessorOf(_indexPath)
            case .OrderedSame: continue
            }

            layoutAttributesForItemAtIndexPath(_indexPath)?.then {
                distance($0) < distance(candidate!) ? candidate = $0 : ()
            }
        }

        snapping.trackedIndexPath = candidate!.indexPath
        return context.then { $0.invalidateItemsAtIndexPaths([candidate!.indexPath]) }
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForCenterPagedItemAtIndexPath(indexPath) ?? super.layoutAttributesForItemAtIndexPath(indexPath)
    }

    // MARK: Override Method

    public func layoutAttributesForCenterPagedItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard snapping.trackedIndexPath == indexPath else { return nil }
        return UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath).then {
            $0.frame = super.layoutAttributesForItemAtIndexPath(indexPath)?.frame ?? .zero
            $0.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }
    }
}

private extension CenterPagedLayout.Snap {

    func distanceFrom(point: CGPoint) -> UICollectionViewLayoutAttributes -> CGFloat {
        let point = CGPointMake(point.x + position.x, point.y + position.y)
        return { CGPointDistanceFrom(fromPoint: $0.center, toPoint: point) }
    }
}

extension CenterPagedLayout.Snap: CustomDebugStringConvertible {

    public var debugDescription: String {
        let track = "Track IndexPath: \(trackedIndexPath?.description)"
        let propose = "Propose IndexPath: \(proposedIndexPath?.description)"
        return [track, propose].joinWithSeparator("\n")
    }
}