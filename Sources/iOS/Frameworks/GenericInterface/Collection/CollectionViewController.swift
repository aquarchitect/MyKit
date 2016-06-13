/*
 * CollectionViewController.swift
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

public class CollectionViewController<T, C: UICollectionViewCell>: UICollectionViewController {

    // MARK: Property

    public var items: [[T]] {
        get { return (collectionView as? CollectionGenericView<T, C>)?.items ?? [] }
        set { (collectionView as? CollectionGenericView<T, C>)?.items = newValue }
    }

    public var config: ((C, T) -> Void)? {
        get { return (collectionView as? CollectionGenericView<T, C>)?.config }
        set { (collectionView as? CollectionGenericView<T, C>)?.config = newValue }
    }

    // MARK: Initialization

    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    // MARK: View LifeCycle

    public override func loadView() {
        collectionView = CollectionGenericView<T, C>(frame: .zero, collectionViewLayout: self.collectionViewLayout)
    }
}
