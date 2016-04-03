//
//  ViewController.swift
//  MyKit-iOSDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

final class ViewController: CollectionViewController<Int, CollectionDynamicCell<UILabel>> {

    init() {
        let layout = MagnifyFlowLayout().then {
            $0.itemSize = CGSizeMake(100, 100)
            $0.minimumLineSpacing = 30
            $0.minimumLineSpacing = 30
        }

        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .whiteColor()

        items = [Array(0..<1000)]
        config = {
            $0.backgroundColor = .blueColor()
            $0.layer.cornerRadius = 5
            $0.mainView.text = "\($1)"
            $0.mainView.textColor = .whiteColor()
            $0.mainView.textAlignment = .Center
        }

        let anchor = self.collectionView?.bounds.center ?? .zero
        let paraboloid: MagnifyLayoutConfig.Paraboloid = {
            let x = -pow(($0 - anchor.x) / 1000, 2)
            let y = -pow(($1 - anchor.y) / 1000, 2)
            return 10 * (x + y) + 1.4
        }

        let range: MagnifyLayoutConfig.Range = (1.0, 1.5)
        (collectionViewLayout as? MagnifyFlowLayout)?.magnifyConfig = MagnifyLayoutConfig(paraboloid: paraboloid, range: range)
    }
}