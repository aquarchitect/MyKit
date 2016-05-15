//
//  UICollectionViewLayout+.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/4/15.
//  
//

public extension UICollectionViewLayout {

    public func register<T: UICollectionReusableView>(type: T.Type, forIdentifier identifier: String) {
        self.registerClass(T.self, forDecorationViewOfKind: identifier)
    }
}