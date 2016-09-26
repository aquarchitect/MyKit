/*
 * ReorderingLongPress.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2016 Hai Nguyen.
 */

import UIKit

/**
 * Warning: this class has no effect on other than Table/Collection view
 */
public class ReorderingLongPress: UILongPressGestureRecognizer {

    internal private(set) var cellSnapshot: UIView?
    internal private(set) var sourceIndexPath: IndexPath?

    internal var tableView: UITableView? {
        return self.view as? UITableView
    }

    internal var collectionView: UICollectionView? {
        return self.view as? UICollectionView
    }

    public func handleGesture() {
        guard let trackingIndexPath = (tableView.flatMap {
            (self.location(in:) >>> $0.indexPathForRow(at:))($0)
        }) else { return }

        guard (tableView.flatMap { $0.dataSource?.tableView?($0, canMoveRowAt: trackingIndexPath) })
            ?? (collectionView.flatMap { $0.dataSource?.collectionView?($0, canMoveItemAt: trackingIndexPath) })
            ?? false else { return }


        switch self.state {
        case .began:
            let cell = tableView?.cellForRow(at: trackingIndexPath)?.then {
                $0.alpha = 1
                $0.isHidden = false
            }

            sourceIndexPath = trackingIndexPath

            cellSnapshot = cell?.snapshotView(afterScreenUpdates: true)?.then {
                $0.backgroundColor = .blue
                $0.frame = tableView?.convert(cell?.frame ?? .zero, to: nil) ?? .zero
                $0.alpha = 0
                $0.clipsToBounds = false
                $0.layer.shadowOffset = CGSize(width: -5, height: 0)
                $0.layer.shadowRadius = 5
                $0.layer.shadowOpacity = 0.4
            }.then {
                UIApplication.shared.keyWindow?.addSubview($0)
            }

            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                cell?.alpha = 0

                self.cellSnapshot?.then {
                    $0.alpha = 0.98
                    $0.center.y = self.location(in: nil).y
                    $0.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
                }, completion: { [weak cell] _ in
                    cell?.isHidden = true
                })
        case .changed:
            cellSnapshot?.center.y = self.location(in: nil).y

            guard let sourceIndexPath = self.sourceIndexPath,
                sourceIndexPath != trackingIndexPath
                else { return }

            /*
             * As table/collection view implementation follows declarative programming,
             * it has data source pointing to itself. This gives you an opportunity
             * to mutate the view models only. The data should be changed on delegation
             * call.
             */
            tableView.flatMap { $0.dataSource?.tableView?($0, moveRowAt: sourceIndexPath, to: trackingIndexPath) }
            collectionView.flatMap { $0.dataSource?.collectionView?($0, moveItemAt: sourceIndexPath, to: trackingIndexPath) }

            self.sourceIndexPath = trackingIndexPath
        default:
            guard let sourceIndexPath = self.sourceIndexPath else { return }

            let cell = tableView?.cellForRow(at: sourceIndexPath)?.then {
                $0.alpha = 0
                $0.isHidden = false
            }

            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                cell?.alpha = 1

                self.cellSnapshot?.then {
                    $0.alpha = 0
                    $0.center.y = self.location(in: nil).y
                    $0.transform = CGAffineTransform.identity
                }
                }, completion: { [weak self] _ in
                    self?.cellSnapshot?.removeFromSuperview()
                    self?.sourceIndexPath = nil
                })
        }
    }
}
