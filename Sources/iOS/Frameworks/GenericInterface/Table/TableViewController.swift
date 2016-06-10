/*
 * TableViewController.swift
 *
 * Copyright (c) 2015–2016 Hai Nguyen (http://aquarchitect.github.io)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public class TableViewController<T, C: UITableViewCell>: UITableViewController {

    public var items: [[T]] {
        get { return (tableView as? TableGenericView<T, C>)?.items ?? [] }
        set { (tableView as? TableGenericView<T, C>)?.items = newValue }
    }

    public var config: ((C, T) -> Void)? {
        get { return (tableView as? TableGenericView<T, C>)?.config }
        set { (tableView as? TableGenericView<T, C>)?.config = newValue }
    }

    private let style: UITableViewStyle

    public override init(style: UITableViewStyle) {
        self.style = style
        super.init(style: style)
    }

    public override func loadView() {
        tableView = TableGenericView<T, C>(frame: .zero, style: style)
    }
}