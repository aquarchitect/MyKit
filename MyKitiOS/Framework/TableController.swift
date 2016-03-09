//
//  TableController.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/5/16.
//
//

public class TableController<T, C: UITableViewCell>: UITableViewController {

    public var items: [[T]] {
        get { return (tableView as? TableView<T, C>)?.items ?? [] }
        set { (tableView as? TableView<T, C>)?.items = newValue }
    }

    public var config: ((C, T) -> Void)? {
        get { return (tableView as? TableView<T, C>)?.config }
        set { (tableView as? TableView<T, C>)?.config = newValue }
    }

    private let style: UITableViewStyle

    public override init(style: UITableViewStyle) {
        self.style = style
        super.init(style: style)
    }

    public override func loadView() {
        tableView = TableView<T, C>(frame: .zero, style: style)
    }
}