// 
// GenericCollectionCell.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

open class GenericCollectionCell<V: UIView>: UICollectionViewCell {

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
