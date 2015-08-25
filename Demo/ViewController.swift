//
//  ViewController.swift
//  Demo
//
//  Created by Hai Nguyen on 8/25/15.
//
//

class ViewController: UICollectionViewController {

    let items = Array(count: 10, repeatedValue: (1...35).map { $0 })

    private var insertedIndexPath: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Normal Cell")
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Special Cell")
        collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count + Int(section == insertedIndexPath?.section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath == insertedIndexPath {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Special Cell", forIndexPath: indexPath)
            cell.backgroundColor = .redColor()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Normal Cell", forIndexPath: indexPath) as! CollectionViewCell
            cell.backgroundColor = .blueColor()
            cell.type = UILabel.self

            let label = cell.view as? UILabel
            label?.text = "\(items[indexPath.section][indexPath.item])"
            label?.textColor = .whiteColor()
            label?.textAlignment = .Center
            
            return cell
        }
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
        header.backgroundColor = .greenColor()

        return header
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.performBatchUpdates({
            let prev = self.insertedIndexPath
            self.insertedIndexPath = nil
            collectionView.deleteItemsAtIndexPaths(prev?.array ?? [])

            }, completion: { _ in
                collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)

                let adjustingIndex = Int(indexPath.section == self.insertedIndexPath?.section)
                let insertedIndex = (Int((indexPath.item - adjustingIndex) / 7) + 1) * 7
                self.insertedIndexPath = NSIndexPath(forItem: insertedIndex, inSection: indexPath.section)

                delay(0.5) { collectionView.insertItemsAtIndexPaths(self.insertedIndexPath?.array ?? []) }
        })
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = indexPath == insertedIndexPath ? collectionView.bounds.width : 44
        return CGSize(width: width, height: 44)
    }
}