/*
 * TableController.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

final class TableController: GenericTableController<String, UITableViewCell>, UICollectionViewDelegate {

    private let layouts: [LayoutPresentable.Type] = [AppleWatchHomeScreenLayout.self, PagedCenterCollectionLayout.self]
    private let shaders: [ShaderKind] = [.Basic]

    init() {
        let items = layouts.map { $0.name } + shaders.map { $0.rawValue }
        let styling: Styling = {
            $0.textLabel?.text = $1
            $0.accessoryType = .DisclosureIndicator
        }

        super.init(style: .Grouped, items: items, styling: styling)
        super.title = "Graphic Experiment"
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Collection Layout"
        case 1: return "Fragment Shader"
        default: return nil
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let layout = layouts[indexPath.row]
            let styling: (UICollectionViewCell, Int) -> Void = {
                $0.0.backgroundColor = UIColor(hexString: Arbitrary.hexString)
                $0.0.layer.cornerRadius = 20
            }

            (layout.init() as? UICollectionViewLayout)?
                .then {
                    GenericCollectionController<Int, UICollectionViewCell>(layout: $0, items: layout.items, styling: styling)
                }.then {
                    $0.collectionView?.then {
                        $0.showsVerticalScrollIndicator = false
                        $0.showsHorizontalScrollIndicator = false
                        $0.backgroundColor = .white
                        $0.delegate = $0.collectionViewLayout is PagedCenterCollectionLayout ? self : nil
                    }
                }.then {
                    self.navigationController?.pushViewController($0, animated: true)
                }
        case 1:
            let shader = shaders[indexPath.row]
            ShaderController(shaderNamed: shader.fileName).then {
                self.navigationController?.pushViewController($0, animated: true)
            }
        default: break
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
}
