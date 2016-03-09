//
//  CollectionController.swift
//  MyKit
//
//  Created by Hai Nguyen on 3/8/16.
//  
//

final public class CollectionController<T, C: UICollectionViewCell>: UICollectionViewController {

    // MARK: Property

    public var items: [[T]] {
        get { return (collectionView as? CollectionView<T, C>)?.items ?? [] }
        set { (collectionView as? CollectionView<T, C>)?.items = newValue }
    }

    public var config: ((C, T) -> Void)? {
        get { return (collectionView as? CollectionView<T, C>)?.config }
        set { (collectionView as? CollectionView<T, C>)?.config = newValue }
    }

    // MARK: Initialization

    public override func loadView() {
        collectionView = CollectionView<T, C>(frame: .zero, collectionViewLayout: self.collectionViewLayout)
    }
}
