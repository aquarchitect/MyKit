/*
 * GenericTableView.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import UIKit

public class GenericTableView<Model: Equatable, Row: UITableViewCell>: UITableView, UITableViewDataSource {

    // MARK: Property

    public fileprivate(set) var rowModels: [Model] = []

    public var rowRenderer: ((Row, Model) -> Void)? {
        didSet { self.reloadData() }
    }

    // MARK: Initialization

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        super.showsHorizontalScrollIndicator = false
        super.register(Row.self, forCellReuseIdentifier: "\(type(of: Row.self))")
        super.dataSource = self
    }

    // MARK: Table View Data Source

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "\(type(of: Row.self))", for: indexPath).then {
            rowRenderer?($0 as! Row, rowModels[indexPath.row])
        }
    }
}

public extension GenericTableView {

    func render(rowModels: [Model], update: Update) {
        switch update {
        case .lscWithAnimation(let animation):
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

            let updates = rowModels.compare(rowModels, range: range, section: 0)
            self.rowModels = rowModels

            self.beginUpdates()
            self.reloadRows(at: updates.reloads, with: animation)
            self.deleteRows(at: updates.deletes, with: animation)
            self.insertRows(at: updates.inserts, with: animation)
            self.endUpdates()
        case .manualHandling(let handle):
            self.rowModels = rowModels
            handle(self)
        }
    }
}
