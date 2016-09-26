/*
 * UIView+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

public extension UIView {

    typealias AnimatingCompletion = (Bool) -> Void
}

public extension UIView {

    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) -> Promise<Bool> {
        return Promise { callback in
            self.animate(withDuration: duration, animations: animations) { callback(.fullfill($0)) }
        }
    }
}
