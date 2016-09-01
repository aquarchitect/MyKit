/*
 * ColorPickerView.swift
 * MyKit
 *
 * Copyright (c) 2016 Hai Nguyen.
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

public protocol ColorPickerViewActionSubscribable: class {

    func userDidPickerColor(hexUInt hexUInt: UInt)
}

public final class ColorPickerView: GenericCollectionView<ColorCollectionCell.Model, ColorCollectionCell>, UICollectionViewDelegate {

    // MARK: Properties

    public weak var actionSubscriber: ColorPickerViewActionSubscribable?

    /**
     * The view will be assigned to the `backgroundView` of the selected cell
     * that is pinned to the left/right edge while scrolling.
     */
    public var pinnedCellBackgroundView: UIView? = UIView().then {
        $0.backgroundColor = UIColor(white: 0.3, alpha: 0.9)
    }

    private var contentCentered = false

    public var selectedHexUInt: UInt? {
        guard let index = self.indexPathsForSelectedItems()?.first?.item else { return nil }
        return cellModels[index].hexUInt
    }

    public override var contentSize: CGSize {
        didSet {
            let sideInset = contentCentered ? max(0, (self.bounds.width - self.contentSize.width)/2) : 0
            self.contentInset.left = sideInset
            self.contentInset.right = sideInset
        }
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(frame: CGRect, contentCentered: Bool = true) {
        self.contentCentered = contentCentered

        let layout = ColorCollectionLayout()

        super.init(frame: frame, collectionViewLayout: layout)
        super.showsVerticalScrollIndicator = false
        super.showsHorizontalScrollIndicator = false
        super.register(ColorCollectionCell.self, forReuseIdentifier: "Cell")
        super.delegate = self

        cellRenderer = { $0.render($1) }
    }

    // MARK: Collection View Delegate

    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard !cellModels[indexPath.item].enabled else { return true }

        /*
         * Even though false is returned, somehow collectionView still deselect current
         * selected cell. dispatch_asynce ensures selected cell in a proper state.
         */
        dispatch_async(Queue.Main) { [weak self] in
            guard let selectedIndexPath = self?.indexPathsForSelectedItems()?.first else { return }
            self?.selectItemAtIndexPath(selectedIndexPath, animated: false, scrollPosition: .None)
        }
        return false
    }

    public func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        (self.cellForItemAtIndexPath(indexPath) as? ColorCollectionCell)?.animateStateChanged()
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        (self.cellForItemAtIndexPath(indexPath) as? ColorCollectionCell)?.animateStateChanged()

        actionSubscriber?.userDidPickerColor(hexUInt: cellModels[indexPath.item].hexUInt)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: Collection View Layout Delegate

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionViewLayout as? ColorCollectionLayout)?.itemSize.width ?? 30
        return CGSizeMake(width, collectionView.bounds.height)
    }
}

// MARK: - Support Methods

public extension ColorPickerView {

    func select(hexUInt hexUInt: UInt) {
        guard hexUInt != selectedHexUInt else { return }

        guard let index = (cellModels.indexOf { $0.hexUInt == hexUInt })
            where cellModels[index].enabled else { return }

        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        
        /*
         * In case the collection view has yet initialized,
         * the selecting operation with be pushed to the next
         * view cycle.
         */
        dispatch_async(Queue.Main) { [weak self] in
            self?.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            self?.collectionViewLayout.invalidateLayout()
        }
    }
}