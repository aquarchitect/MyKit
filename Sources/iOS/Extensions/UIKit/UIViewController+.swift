// 
// UIViewController+.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

public extension UIViewController {

    func present(controller: UIViewController, animated flag: Bool) -> Observable<Void> {
        return Observable().then {
            self.present(controller, animated: flag, completion: $0.update)
        }
    }

    func dismissViewController(animated flag: Bool) -> Observable<Void> {
        return Observable().then {
            self.dismiss(animated: flag, completion: $0.update)
        }
    }
}
