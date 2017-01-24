/*
 * NSTableView+.swift
 * MyKit
 *
 * Created by Hai Nguyen on 1/23/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import AppKit

public extension NSTableView {

    /// The implementation takes a snapshot of the table view
    /// to capture its current state before invoking `reloadData`.
    /// The idea is to mimic the transition animation of 
    /// `pushViewController` on iOS.
    ///
    /// - Parameters:
    ///   - edge: rectangular edge where to start animation from.
    ///     + minXEdge: left to right animation
    ///     + maxXEdge: right to left animation
    ///     + minYEdge: bottom to top animation
    ///     + maxYEdge: top to bottom animation
    ///   - animation: animation block
    ///   - completion: completion block
    func transition(from edge: CGRectEdge, animation: (NSAnimationContext) -> Void, completion: (() -> Void)?) {
        let snapshotView = self.snapshotView()?.then {
            $0.frame.origin = self.frame.origin
            self.superview?.addSubview($0)
        }

        let initialOrigin = self.frame.origin
        self.position(at: edge)
        self.reloadData()

        NSAnimationContext.runAnimationGroup({
            self.frame.origin = initialOrigin
            snapshotView?.position(at: edge.opposite)

            animation($0)
        }, completionHandler: {
            snapshotView?.removeFromSuperview()
            completion?()
        })
    }
}
