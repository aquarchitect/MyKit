//
//  UIViewController+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/11/16.
//  
//

public extension UIViewController {

    public func showsAlert(title: String? = nil, message: String) {
        UIAlertController(title: title, message: message, preferredStyle: .Alert).then {
            self.presentViewController($0, animated: true, completion: nil)
            delay(0.5) { self.dismissViewControllerAnimated(true, completion: nil) }
        }
    }
}