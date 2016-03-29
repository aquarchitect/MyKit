//
//  CollectionViewController.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

final public class CollectionViewController<T, C: UICollectionViewCell>: UICollectionViewController {

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

    public override func loadView() {
        collectionView = CollectionGenericView<T, C>(frame: .zero, collectionViewLayout: self.collectionViewLayout)
    }
}
