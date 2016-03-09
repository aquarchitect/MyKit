//
//  CollectionCell.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/18/16.
//
//

public class CollectionCell<V: UIView where V: Then>: UICollectionViewCell {

    // MARK: Property

    public let presentView = V().then {
        $0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.contentView.addSubview(presentView)

        presentView.frame = self.bounds
    }
}