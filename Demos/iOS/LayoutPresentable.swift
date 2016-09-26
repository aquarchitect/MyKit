/*
 * LayoutPresentable.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

protocol LayoutPresentable: class {

    static var name: String { get }
    static var items: [Int] { get }
    init()
}
