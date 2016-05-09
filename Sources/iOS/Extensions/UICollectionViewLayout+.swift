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

extension UICollectionViewLayout {

    func snappingContentOffset(`for` proposedContentOffset: CGPoint, atPoint point: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return proposedContentOffset }
        let rect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)

        let distance: UICollectionViewLayoutAttributes -> CGFloat = {
            let center = $0.center.shiftToCoordinate(proposedContentOffset)
            return CGPointDistanceToPoint(center, point)
        }

        return (self.layoutAttributesForElementsInRect(rect) ?? [])
            .filter { $0.representedElementCategory == .Cell }.lazy
            .sort { distance($0) < distance($1) }.lazy.first?
            .then { CGPointMake($0.center.x - point.x, $0.center.y - point.y) }
            ?? proposedContentOffset
    }
}