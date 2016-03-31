//
//  CollectionLayoutSnappingUserInfo.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/30/16.
//  
//

final public class CollectionLayoutSnappingUserInfo {

    var trackedIndexPath: NSIndexPath
    var proposedIndexPath: NSIndexPath

    var anchorPosition: CGPoint

    init(indexPath: NSIndexPath, position: CGPoint) {
        self.trackedIndexPath = NSIndexPath(indexes: indexPath.indexes)
        self.proposedIndexPath = NSIndexPath(indexes: indexPath.indexes)
        self.anchorPosition = position
    }
}

extension CollectionLayoutSnappingUserInfo {

    func distanceFrom(point: CGPoint) -> UICollectionViewLayoutAttributes -> CGFloat {
        let point = CGPointMake(point.x + anchorPosition.x, point.y + anchorPosition.y)
        return { CGPointDistanceFrom(fromPoint: $0.center, toPoint: point) }
    }
}

extension CollectionLayoutSnappingUserInfo: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Tracking: \(trackedIndexPath.debugDescription)"
    }
}