//
//  ViewController.swift
//  MyKit-iOSDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

final class ViewController: CollectionViewController<Int, CollectionDynamicCell<UILabel>> {

    init() {
        let layout = CenterPagedLayout(snappingPosition: CGPointMake(100, 100)).then {
            $0.itemSize = CGSizeMake(44, 44)
            $0.minimumLineSpacing = 2
            $0.minimumLineSpacing = 2
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
}

