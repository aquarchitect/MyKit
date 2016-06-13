/*
 * NavigationController.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

final class NavigationController: UINavigationController {

    private let layouts = ["Apple Watch Home Screen", "Magnifying", "Centering", "Snapping"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootController = TableViewController<String, UITableViewCell>(style: .Plain)
        rootController.title = "Collection Layouts"
        rootController.items = [layouts]
        rootController.config = {
            $0.textLabel?.text = $1
            $0.accessoryType = .DisclosureIndicator
        }
        rootController.tableView.delegate = self

        self.setViewControllers([rootController], animated: true)
    }
}

extension NavigationController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var controller: UICollectionViewController?

        switch layouts[indexPath.row] {
        case "Apple Watch Home Screen":
            class Controller: UICollectionViewController {

                override func loadView() {
                    let layout = MagnifyingFluidLayout()
                        .then { $0.snappingPoint = UIScreen.mainScreen().bounds.center }

                    collectionView = CollectionGenericView<Int, UICollectionViewCell>(frame: .zero, collectionViewLayout: layout).then {
                        $0.backgroundColor = .whiteColor()
                        $0.items = [Array(count: 400, repeatedValue: 0)]
                        $0.config = {
                            $0.0.backgroundColor = UIColor(hexCode: Arbitrary.hexCode)
                            $0.0.layer.cornerRadius = 5
                        }
                    }
                }
            }

            controller = Controller()

        case "Magnifying":
            class Controller: UICollectionViewController {

                override func loadView() {
                    let length: CGFloat = 50

                    let layout = MagnifyingFlowLayout().then {
                        $0.magnifyingConfig = MagnifyingLayoutConfig()
                        $0.snappingPoint = UIScreen.mainScreen().bounds.center
                        $0.itemSize = CGSize(sideLength: length)
                        $0.minimumLineSpacing = 5
                        $0.minimumInteritemSpacing = 5
                        $0.scrollDirection = .Vertical
                    }

                    collectionView = CollectionGenericView<Int, UICollectionViewCell>(frame: .zero, collectionViewLayout: layout).then {
                        $0.contentInset.top = length / 2
                        $0.contentInset.bottom = length / 2

                        $0.backgroundColor = .whiteColor()
                        $0.items = [Array(count: 200, repeatedValue: 0)]
                        $0.config = {
                            $0.0.backgroundColor = UIColor(hexCode: Arbitrary.hexCode)
                            $0.0.layer.cornerRadius = 5
                        }
                    }
                }
            }

            controller = Controller()

        case "Centering":
            class Controller: UICollectionViewController {

                override func loadView() {
                    let layout = CenteringGroupedLayout().then {
                        $0.cornerRadii = CGSize(sideLength: 10)
                        $0.sectionInset = UIEdgeInsets(sideLength: 20)
                    }

                    collectionView = CollectionGenericView<Int, CenteringRoundedCell>(frame: .zero, collectionViewLayout: layout).then {
                        $0.backgroundColor = .whiteColor()
                        $0.items = Array(count: 3, repeatedValue: Array(count: 10, repeatedValue: 0))
                        $0.config = { $0.0.backgroundColor = UIColor(hexCode: Arbitrary.hexCode) }
                    }
                }
            }

            controller = Controller()

        case "Snapping": break
        default: break
        }

        controller?.then { self.pushViewController($0, animated: true) }
    }
}