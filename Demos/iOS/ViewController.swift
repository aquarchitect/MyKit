//
//  ViewController.swift
//  MyKit-iOSDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

final class ViewController: CollectionViewController<Int, CollectionDynamicCell<UILabel>> {

    init() {
        let layout = CollectionSnapFlowLayout().then {
            $0.itemSize = CGSizeMake(100, 100)
            $0.minimumLineSpacing = 10
            $0.minimumLineSpacing = 10
        }

        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .whiteColor()

        items = [Array(0..<200)]
        config = {
            $0.backgroundColor = .blueColor()
            $0.mainView.text = "\($1)"
            $0.mainView.textColor = .whiteColor()
            $0.mainView.textAlignment = .Center
        }
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionViewLayout
            .then { $0 as? CollectionSnapFlowLayout }?
            .then { $0.snappedIndexPath = $0.snappedIndexPath == indexPath ? nil : indexPath }
    }
}