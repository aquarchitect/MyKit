//
//  TableView.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/11/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class TableView: UITableView {

    public let items: [[Any]]
    private let config: (UITableViewCell, Any) -> Void

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init<T>(items: [[T]], configure: (UITableViewCell, T) -> Void) {
        self.items = items.map { $0.map { Box($0) } }
        self.config = {
            guard let value = $1 as? Box<T> else { return }
            configure($0, value.unbox)
        }

        super.init(frame: CGRectZero, style: .Plain)
        super.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        super.dataSource = self
        super.delegate = self
    }
}

extension TableView: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    final public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        config(cell, items[indexPath.section][indexPath.item])

        return cell
    }
}