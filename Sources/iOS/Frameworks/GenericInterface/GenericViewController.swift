/*
 * GenericViewController.swift
 * MyKit
 *
 * Created by Hai Nguyen on 1/18/17.
 * Copyright (c) 2017 Hai Nguyen.
 */

import UIKit

open class GenericViewController<V: UIView>: UIViewController {

    open override func loadView() {
        view = V()
    }
}
