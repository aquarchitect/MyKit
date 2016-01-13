//
//  TableView.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/11/15.
//  Copyright © 2015 Hai Nguyen. All rights reserved.
//

public class TableView<T, C: UITableViewCell>: UITableView, UITableViewDataSource {

    public var items: [[T]] = []

    public var config: ((C, T) -> Void)?

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.registerClass(C.self, forCellReuseIdentifier: "Cell")
        super.dataSource = self
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! C
        config?(cell, items[indexPath.section][indexPath.row])

        return cell
    }
}