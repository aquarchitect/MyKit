//
//  DynamicCell.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/18/16.
//
//

public class DynamicCell<V: UIView where V: Setup>: UICollectionViewCell {

    public let presentView = V().setup {
        $0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.contentView.addSubview(presentView)

        presentView.frame = self.bounds
    }
}