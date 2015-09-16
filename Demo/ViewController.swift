//
//  ViewController.swift
//  Demo
//
//  Created by Hai Nguyen on 8/25/15.
//
//

class ViewController: UITableViewController {

    private var cachedCells = [NSIndexPath: UITableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 50

        (0..<20).forEach {
            let indexPath = NSIndexPath(forRow: $0, inSection: 0)

            let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
            cell.textLabel?.text = "Object at \(indexPath.description)"
            cell.textLabel?.textColor = .whiteColor()
            cell.backgroundColor = UIColor.arbitrary()

            self.cachedCells[indexPath] = cell
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cachedCells.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cachedCells[indexPath]!
    }
}