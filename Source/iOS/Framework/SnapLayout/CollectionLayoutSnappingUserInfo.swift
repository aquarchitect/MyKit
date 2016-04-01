//
//  CollectionLayoutSnappingUserInfo.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/30/16.
//  
//

final public class CollectionLayoutSnappingUserInfo {

    var centeredIndexPath: NSIndexPath
    var proposedIndexPath: NSIndexPath

    var anchorPosition: CGPoint

    init(indexPath: NSIndexPath, position: CGPoint) {
        self.centeredIndexPath = NSIndexPath(indexes: indexPath.indexes)
        self.proposedIndexPath = NSIndexPath(indexes: indexPath.indexes)
        self.anchorPosition = position
    }
}

extension CollectionLayoutSnappingUserInfo {

    func distanceFrom(point: CGPoint) -> UICollectionViewLayoutAttributes -> CGFloat {
        let point = CGPointMake(point.x + anchorPosition.x, point.y + anchorPosition.y)
        return { CGPointDistanceToPoint($0.center, point) }
    }
}

extension CollectionLayoutSnappingUserInfo: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Tracking: \(centeredIndexPath.debugDescription)"
    }
}