//
//  UITableView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UITableView {

    // MARK: Transform IndexPath

    final func forwardIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row < self.numberOfRowsInSection(indexPath.section) - 1 {
            return NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections - 1 {
            return NSIndexPath(forRow: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func backwardIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row > 0 {
            return NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let row = self.numberOfRowsInSection(section) - 1

            return NSIndexPath(forRow: row, inSection: section)
        } else { return nil }
    }

    // MARK: Register Reusable Views

    public func register<T: UITableViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(T.self, forCellReuseIdentifier: identifier)
    }

    public func register<T: UITableViewHeaderFooterView>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }

    // MARK: Miscellaneous

    final func isSectionValid(section: Int) -> Bool {
        return NSLocationInRange(section, NSMakeRange(0, self.numberOfSections))
    }
}