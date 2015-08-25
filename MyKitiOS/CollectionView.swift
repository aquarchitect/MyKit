//
//  CollectionView.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/26/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class CollectionView: UICollectionView {

    public let items: [Any]
    private let type: UIView.Type
    private let config: (CollectionViewCell, Any) -> Void

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init<T, V where V: UIView>(items: [T], configure: (UICollectionViewCell, V, T) -> Void) {
        self.items = items.map { Box($0) }
        self.type = V.self
        self.config = {
            guard let value = $1 as? Box<T> else { return }
            configure($0, $0.view as! V, value.unbox)
        }

        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewLayout())
        super.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        super.dataSource = self
    }
}

extension CollectionView: UICollectionViewDataSource {


    public final func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    final public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        cell.type = type
        config(cell, items[indexPath.item])

        return cell
    }
}

public class CollectionViewCell: UICollectionViewCell {

    public var type: UIView.Type!

    public private(set) lazy var view: UIView = {
        let view = self.type.init(frame: self.bounds)
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.contentView.addSubview(view)

        return view
        }()
}