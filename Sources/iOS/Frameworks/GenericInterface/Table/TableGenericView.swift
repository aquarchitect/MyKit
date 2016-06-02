//
//  TableGenericView.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/11/15.
//  
//

import UIKit

public class TableGenericView<T, C: UITableViewCell>: UITableView, UITableViewDataSource {

    public var items: [[T]] = []

    public var config: ((C, T) -> Void)?

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.register(C.self, forReuseIdentifier: "Cell")
        super.dataSource = self
    }

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath).then {
            config?($0 as! C, items[indexPath.section][indexPath.row])
        }
    }
}