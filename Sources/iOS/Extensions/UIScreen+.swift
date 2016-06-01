//
//  UIScreen+.swift
//  MyKit
//
//  Created by Hai Nguyen on 4/15/16.
//  
//

public extension UIScreen {

    enum Orientation { case Portrait, Landscape }

    var interfaceOrientation: Orientation {
        return self.bounds.width <= self.bounds.height ? .Portrait : .Landscape
    }

    var propotionalWidth: CGFloat {
        let ratio: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 1 : 2/3
        return min(self.bounds.width, self.bounds.height) * ratio
    }
}