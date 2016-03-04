//
//  UICollectionView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public extension UICollectionView {

    private class Hold: NSObject {

        static var Key = "Hold"

        var anchorIndexPath: NSIndexPath?
        var trackedIndexPath: NSIndexPath?

        override func copy() -> AnyObject {
            return self
        }
    }

    final func setupMultiSelection() {
        self.allowsMultipleSelection = true

        let hold = UILongPressGestureRecognizer()
        hold.addTarget(self, action: "handleHold:")
        self.addGestureRecognizer(hold)

        objc_setAssociatedObject(self, &Hold.Key, Hold(), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }

    internal func handleHold(sender: UILongPressGestureRecognizer) {
        let location = sender.locationInView(self)
        guard let hold = objc_getAssociatedObject(self, &Hold.Key) as? Hold,
            indexPath = self.indexPathForItemAtPoint(location) else { return }

        switch sender.state {

        case .Began:
            self.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            hold.anchorIndexPath = indexPath
            hold.trackedIndexPath = indexPath
        case .Changed:
            guard indexPath != hold.trackedIndexPath else { return }
            self.selectItemsToIndexPath(indexPath)
        default:
            hold.anchorIndexPath = nil
            hold.trackedIndexPath = nil
        }
    }

    private func selectItemsToIndexPath(indexPath: NSIndexPath) {
        guard let hold = objc_getAssociatedObject(self, &Hold.Key) as? Hold,
            anchorIndexPath = hold.anchorIndexPath, trackedIndexPath = hold.trackedIndexPath else { return }
        guard let frontIndexPath = self.forwardIndexPath(trackedIndexPath),
            backIndexPath = self.backwardIndexPath(trackedIndexPath) else { return }

        switch trackedIndexPath.compare(indexPath) {

        case .OrderedAscending:
            guard let cell = self.cellForItemAtIndexPath(backIndexPath) else { return }

            if trackedIndexPath != anchorIndexPath {
                cell.selected ? self.selectItemAtIndexPath(trackedIndexPath, animated: false, scrollPosition: .None) : self.deselectItemAtIndexPath(trackedIndexPath, animated: false)
            }

            hold.trackedIndexPath = frontIndexPath
            selectItemsToIndexPath(indexPath)

        case .OrderedDescending:
            guard let cell = self.cellForItemAtIndexPath(frontIndexPath) else { return }

            if trackedIndexPath != anchorIndexPath {
                cell.selected ? self.selectItemAtIndexPath(trackedIndexPath, animated: false, scrollPosition: .None) : self.deselectItemAtIndexPath(trackedIndexPath, animated: false)
            }

            hold.trackedIndexPath = backIndexPath
            selectItemsToIndexPath(indexPath)
        case .OrderedSame:
            self.selectItemAtIndexPath(trackedIndexPath, animated: true, scrollPosition: .None)
        }
    }
}

public extension UICollectionView {

    final func cellHandleAtIndexPath<T>(indexPath: NSIndexPath, handle: T -> Void) {
        if let cell = self.cellForItemAtIndexPath(indexPath) as? T { handle(cell) }
    }

    final func forwardIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item < self.numberOfItemsInSection(indexPath.section) - 1 {
            return NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections() - 1 {
            return NSIndexPath(forItem: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func backwardIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item > 0 {
            return NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let item = self.numberOfItemsInSection(section) - 1

            return NSIndexPath(forItem: item, inSection: section)
        } else { return nil }
    }

    public func register<T: UICollectionViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(T.self, forCellWithReuseIdentifier: identifier)
    }

    public func register<T: UICollectionReusableView>(type: T.Type, forKind kind: String, withReuseIdentifier identifier: String) {
        self.registerClass(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}