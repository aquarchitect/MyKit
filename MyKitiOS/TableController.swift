//
//  TableController.swift
//  MyKit
//
//  Created by Hai Nguyen on 1/5/16.
//
//

public class TableController<T, C: UITableViewCell>: UITableViewController {

    public var items: [[T]] {
        get { return (tableView as? TableView)?.items ?? [] }
        set { (tableView as? TableView)?.items = newValue }
    }

    public var config: ((C, T) -> Void)? {
        get { return (tableView as? TableView)?.config }
        set { (tableView as? TableView)?.config = newValue }
    }

    private let style: UITableViewStyle

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(style: UITableViewStyle) {
        self.style = style
        super.init(style: style)
    }

    public override func loadView() {
        tableView = TableView<T, C>(frame: .zero, style: style)
    }
}