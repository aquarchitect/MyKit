/*
 * ViewModel.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

public protocol ViewModelRendering: class {

    func renderComponent<T>(_ model: ViewModel<T>)
}

public struct ViewModel<T> {

    public let value: T

    public init(_ value: T) {
        self.value = value
    }
}

#if os(iOS)
import UIKit

public extension UIViewController {

    func renderComponentView<T>(_ model: ViewModel<T>) {
        (view as? ViewModelRendering)?.renderComponent(model)
    }
}
#elseif os(OSX)
import AppKit

public extension NSViewController {

    func renderComponentView<T>(_ model: ViewModel<T>) {
        (view as? ViewModelRendering)?.renderComponent(model)
    }
}
#endif
