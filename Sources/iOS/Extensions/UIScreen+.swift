//
//  UIScreen+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/15/16.
//  
//

public extension UIScreen {

    public static var propotionalWidth: CGFloat {
        let size = mainScreen().bounds.size
        let width = min(size.width, size.height)
        let ratio: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 1 : 2/3

        return width * ratio
    }
}