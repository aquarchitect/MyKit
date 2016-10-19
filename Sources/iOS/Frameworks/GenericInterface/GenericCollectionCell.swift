/*
 * GenericCollectionCell.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

#if swift(>=3.0)
open class GenericCollectionCell<V: UIView>: UICollectionViewCell where V: Then {

    // MARK: Property

    open let mainView = V().then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        mainView.frame = self.bounds
        self.contentView.addSubview(mainView)
    }
}
#else
public class GenericCollectionCell<V: UIView where V: Then>: UICollectionViewCell {

    // MARK: Property

    public let mainView = V().then {
        $0.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        mainView.frame = self.bounds
        self.contentView.addSubview(mainView)
    }
}
#endif
