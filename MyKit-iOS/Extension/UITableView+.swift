//
//  UITableView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UITableView {

    // MARK: Miscellaneous

    final func isSectionValid(section: Int) -> Bool {
        return NSLocationInRange(section, NSMakeRange(0, self.numberOfSections))
    }

    // MARK: Transform IndexPath

    final func successorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row < self.numberOfRowsInSection(indexPath.section) - 1 {
            return NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return NSIndexPath(forRow: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func predecessorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row > 0 {
            return NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let row = self.numberOfRowsInSection(section) - 1

            return NSIndexPath(forRow: row, inSection: section)
        } else { return nil }
    }

    // MARK: Register Views

    public func register<T: UITableViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(type, forCellReuseIdentifier: identifier)
    }

    public func register<T: UITableViewHeaderFooterView>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(type, forHeaderFooterViewReuseIdentifier: identifier)
    }
}