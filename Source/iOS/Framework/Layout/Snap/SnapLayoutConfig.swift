//
//  SnapLayoutConfig.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/5/16.
//  
//

/*
 * SnapRootLayout & SnapFlowLayout have almost identical codes,
 * except that SnapFlowLayout accesses the root of cell attributes.
 * Note: propotcol and swizzling methods have been considered; I belive
 * that repeating codes can give the edge of optimization.
 */

final class SnapLayoutConfig {

    var indexPath: NSIndexPath
    let anchorPosition: CGPoint

    init(indexPath: NSIndexPath, anchorPosition position: CGPoint) {
        self.indexPath = indexPath
        self.anchorPosition = position
    }
}