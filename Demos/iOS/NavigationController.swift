//
//  NavigationController.swift
//  MyKitDemo
//
//  Created by Hai Nguyen on 3/29/16.
//
//

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
                    let layout = MagnifyingIndentedLayout()
                        .then { $0.snappingPoint = UIScreen.mainScreen().bounds.center }

                    collectionView = CollectionGenericView<Int, UICollectionViewCell>(frame: .zero, collectionViewLayout: layout).then {
                        $0.backgroundColor = .whiteColor()
                        $0.items = [Array(count: 400, repeatedValue: 0)]
                        $0.config = {
                            $0.0.backgroundColor = Arbitrary.Color.randomValue()
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
                            $0.0.backgroundColor = Arbitrary.Color.randomValue()
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
                        $0.config = { $0.0.backgroundColor = Arbitrary.Color.randomValue() }
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