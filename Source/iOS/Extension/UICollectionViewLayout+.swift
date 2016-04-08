//
//  UICollectionViewLayout+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/4/15.
//  
//

public extension UICollectionViewLayout {

    public func register<T: UICollectionReusableView>(type: T.Type, forIdentifier identifier: String) {
        self.registerClass(T.self, forDecorationViewOfKind: identifier)
    }
}

public extension UICollectionViewLayout {

    private class Snapper: NSObject {

        static var Dispatch: dispatch_once_t = 0
        static var Key = String(self.dynamicType)

        let point: CGPoint

        init(point: CGPoint) {
            self.point = point
        }

        override func copy() -> AnyObject {
            return self
        }
    }

    // MARK: Property

    public var snappedPoint: CGPoint? {
        get { return snapper?.point }
        set {
            guard let point = newValue else { return snapper = nil }
            snapper = Snapper(point: point)

            // TODO: Scroll collection view to the best possible snapping position
        }
    }

    private var snapper: Snapper? {
        get { return objc_getAssociatedObject(self, &Snapper.Key) as? Snapper }
        set { objc_setAssociatedObject(self, &Snapper.Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    // MARK: Support Method

    func snappedTargetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var targetContentOffset = proposedContentOffset

        if let snappedPoint = self.snappedPoint, collectionView = self.collectionView {
            let rect = CGRect(origin: targetContentOffset, size: collectionView.bounds.size)

            let distance: UICollectionViewLayoutAttributes -> CGFloat = {
                let center = $0.center.shiftToCoordinate(targetContentOffset)
                return CGPointDistanceToPoint(center, snappedPoint)
            }

            targetContentOffset = (self.layoutAttributesForElementsInRect(rect) ?? [])
                .filter { $0.representedElementCategory == .Cell }.lazy
                .sort { distance($0) < distance($1) }.lazy.first?
                .andThen { CGPointMake($0.center.x - snappedPoint.x, $0.center.y - snappedPoint.y) }
                ?? targetContentOffset
        }

        return snappedTargetContentOffsetForProposedContentOffset(targetContentOffset, withScrollingVelocity: velocity)
    }

    // MARK: System Method

    public override class func initialize() {
        dispatch_once(&Snapper.Dispatch) {
            swizzle(UICollectionViewLayout.self,
                original: #selector(targetContentOffsetForProposedContentOffset(_:withScrollingVelocity:)),
                swizzled: #selector(snappedTargetContentOffsetForProposedContentOffset(_:withScrollingVelocity:)))
        }
    }
}