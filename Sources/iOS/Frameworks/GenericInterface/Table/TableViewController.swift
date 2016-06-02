//
//  TableViewController.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/5/16.
//
//

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