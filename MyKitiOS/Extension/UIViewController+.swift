//
//  UIViewController+.swift
//  MyKit
//
//  Created by Hai Nguyen on 2/11/16.
//  
//

public extension UIViewController {

    public func showsAlert(title: String? = nil, message: String) {
        let action = UIAlertAction(title: "OK", style: .Default) { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        UIAlertController(title: title, message: message, preferredStyle: .Alert).then {
            $0.addAction(action)
            self.presentViewController($0, animated: true, completion: nil)
        }
    }
}