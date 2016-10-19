/*
 * UIViewController+.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public extension UIViewController {

#if swift(>=3.0)
    func present(controller: UIViewController, animated flag: Bool) -> Promise<Void> {
        return Promise { callback in
            self.present(controller, animated: flag) { callback(.fulfill()) }
        }
    }

    func dismissViewController(animated flag: Bool) -> Promise<Void> {
        return Promise { callback in
            self.dismiss(animated: flag) { callback(.fulfill()) }
        }
    }
#else
    func presentViewController(controller: UIViewController, animated flag: Bool) -> Promise<Void> {
        return Promise { callback in
            self.presentViewController(controller, animated: flag) { callback(.fulfill()) }
        }
    }

    func dismissViewController(animated flag: Bool) -> Promise<Void> {
        return Promise { callback in
            self.dismissViewControllerAnimated(flag) { callback(.fulfill()) }
        }
    }
#endif
}
