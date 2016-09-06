/*
 * UICollectionView+.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// MARK: - Miscellaneous

/// :nodoc:
public extension UICollectionView {

    final func hasSection(section: Int) -> Bool {
        return 0..<self.numberOfSections() ~= section
    }

    final func recalibrateRowTagsWithIndexPaths() {
        self.indexPathsForVisibleItems().forEach {
            self.cellForItemAtIndexPath($0)?.tag = serialize($0)
        }
    }
}

// MARK: Transform IndexPath

public extension UICollectionView {

    final func successorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item < self.numberOfItemsInSection(indexPath.section) - 1 {
            return NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections() - 1 {
            return NSIndexPath(forItem: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func predecessorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item > 0 {
            return NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let item = self.numberOfItemsInSection(section) - 1

            return NSIndexPath(forItem: item, inSection: section)
        } else { return nil }
    }

    final func serialize(indexPath: NSIndexPath) -> Int {
        return (0..<indexPath.section)
            .map { self.numberOfItemsInSection($0) }
            .lazy
            .reduce(indexPath.row, combine: +)
    }

    final func deserialize(index: Int) -> NSIndexPath {
        var (section, count) = (0, 0)

        while case let rows = self.numberOfItemsInSection(section) where count + rows < index {
            count += rows
            section += 1
        }

        return NSIndexPath(forRow: index - count, inSection: section)
    }
}

// MARK: Register Reusable View

public extension UICollectionView {

    final func register<T: UICollectionViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(T.self, forCellWithReuseIdentifier: identifier)
    }

    final func register<T: UICollectionReusableView>(type: T.Type, forKind kind: String, withReuseIdentifier identifier: String) {
        self.registerClass(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}

/// :nodoc:
public extension UICollectionView {

    /*
     * Dragger needs to be an object
     * in order to user with associatedObject.
     */
    private class Dragger: NSObject {

        static var Key = String(self.dynamicType)

        let gesture = UILongPressGestureRecognizer()

        var anchor: NSIndexPath?
        var tracker: NSIndexPath?

        override func copy() -> AnyObject {
            return self
        }
    }

    private var dragger: Dragger? {
        get { return objc_getAssociatedObject(self, &Dragger.Key) as? Dragger }
        set {
            dragger?.gesture.then(self.removeGestureRecognizer)

            newValue?.gesture.then {
                $0.addTarget(self, action: #selector(handleMultipleSelectionByDragging(_:)))
                self.addGestureRecognizer($0)
            }

            objc_setAssociatedObject(self, &Dragger.Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    public var allowsMultipleSelectionByDragging: Bool {
        get { return dragger != nil }
        set { dragger = newValue ? Dragger() : nil }
    }

    internal final func handleMultipleSelectionByDragging(sender: UILongPressGestureRecognizer) {
        guard case let location = sender.locationInView(self),
            let indexPath = self.indexPathForItemAtPoint(location),
            dragger = self.dragger else { return }

        switch sender.state {

        case .Began:
            self.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            dragger.anchor = indexPath
            dragger.tracker = indexPath

        case .Changed:
            guard indexPath != dragger.tracker else { return }
            selectItemsRecursively(indexPath)

        default:
            dragger.anchor = nil
            dragger.tracker = nil
        }
    }

    private final func selectItemsRecursively(destination: NSIndexPath) {
        guard let dragger = self.dragger,
            anchor = dragger.anchor,
            tracker = dragger.tracker
            else { return }

        guard let frontIndexPath = successorOf(tracker),
            backIndexPath = predecessorOf(tracker)
            else { return }

        switch tracker.compare(destination) {

        case .OrderedAscending:
            guard let cell = self.cellForItemAtIndexPath(backIndexPath) else { return }

            if tracker != anchor {
                cell.selected
                    ? self.selectItemAtIndexPath(tracker, animated: false, scrollPosition: .None)
                    : self.deselectItemAtIndexPath(tracker, animated: false)
            }

            dragger.tracker = frontIndexPath
            selectItemsRecursively(destination)
        case .OrderedDescending:
            guard let cell = self.cellForItemAtIndexPath(frontIndexPath) else { return }

            if tracker != anchor {
                cell.selected
                    ? self.selectItemAtIndexPath(tracker, animated: false, scrollPosition: .None)
                    : self.deselectItemAtIndexPath(tracker, animated: false)
            }

            dragger.tracker = backIndexPath
            selectItemsRecursively(destination)
        case .OrderedSame:
            self.selectItemAtIndexPath(tracker, animated: true, scrollPosition: .None)
        }
    }
}