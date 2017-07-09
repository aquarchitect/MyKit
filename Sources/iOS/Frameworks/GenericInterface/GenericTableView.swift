//
// GenericTableView.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

import UIKit

@available(*, deprecated)
open class GenericTableView<Model: Hashable, Row: UITableViewCell>: UITableView, UITableViewDataSource {

    // MARK: Property

    open var rowRenderer: ((Row, Model) -> Void)? {
        didSet { self.reloadData() }
    }

    open fileprivate(set) var rowModels: [Model] = [] {
        didSet {
            // Giving an estimated range of possibly visible row
            // will speed up the diff computation on a much narrow
            // subset of elements.
            let range: Range<Int> = {
                let startIndex = self.indexPathsForVisibleRows?.first?.row ?? 0
                let endIndex = startIndex + estimatedNumberOfVisibleRows
                return .init(startIndex ... endIndex)
            }()

            let (deletes, inserts, updates) = oldValue.compareUsingLCS(
                rowModels, in: range,
                transformer: IndexPath(index: 0).appending
            )

            self.beginUpdates()
            self.deleteRows(at: deletes, with: .automatic)
            self.insertRows(at: inserts, with: .automatic)
            self.endUpdates()

            self.reloadRows(at: updates, with: .fade)
        }
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.register(Row.self, forCellReuseIdentifier: "\(type(of: Row.self))-0")
        super.dataSource = self
    }

    // MARK: Table View Data Source

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowModels.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "\(type(of: Row.self))-0", for: indexPath).then {
            rowRenderer?($0 as! Row, rowModels[indexPath.row])
        }
    }
}
