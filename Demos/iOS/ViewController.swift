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

        dispatch_async(Queue.Main) { [weak layout] in
            layout?.snappedIndexPath = NSIndexPath(forItem: 4, inSection: 0)
        }

        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.then {
            $0.backgroundColor = .whiteColor()
            $0.contentInset.top = 50
        }

        items = [Array(0..<200)]
        config = {
            $0.backgroundColor = .blueColor()
            $0.mainView.text = "\($1)"
            $0.mainView.textColor = .whiteColor()
            $0.mainView.textAlignment = .Center
        }
    }
}