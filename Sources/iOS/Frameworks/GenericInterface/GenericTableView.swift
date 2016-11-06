/*
 * GenericTableView.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

open class GenericTableView<Model: Equatable, Row: UITableViewCell>: UITableView, UITableViewDataSource {

    // MARK: Property

    open fileprivate(set) var rowModels: [Model] = []

    open var rowRenderer: ((Row, Model) -> Void)? {
        didSet { self.reloadData() }
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

public extension GenericTableView {

    func render(_ rowModels: [Model], update: Update) {
        switch update {
        case .lcs:
            /*
             * Giving an estimated range of possibly visible row 
             * will speed up the diff computation on a much narrow
             * subset of elements.
             */
            let range: CountableRange<Int> = {
                let startIndex = self.indexPathsForVisibleRows?.first?.row ?? 0
                let endIndex = startIndex + estimatedNumberOfVisibleRows
                return .init(startIndex ... endIndex)
            }()

            let updates = self.rowModels.compare(rowModels, range: range, section: 0)
            self.rowModels = rowModels

            self.beginUpdates()
            self.reloadRows(at: updates.reloads, with: .automatic)
            self.deleteRows(at: updates.deletes, with: .fade)
            self.insertRows(at: updates.inserts, with: .automatic)
            self.endUpdates()
        case .forcefull:
            self.rowModels = rowModels
            self.reloadData()
        }
    }
}
