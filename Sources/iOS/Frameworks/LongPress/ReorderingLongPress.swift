// 
// ReorderingLongPress.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2016 Hai Nguyen.
// 

import UIKit

/// Reoder `UICollectionView` cell or `UITableView` row with
/// long press gesture.
open class ReorderingLongPress: UILongPressGestureRecognizer {

    // MARK: Properties

    internal private(set) var cellSnapshot: UIView?
    internal private(set) var sourceIndexPath: IndexPath?

    internal var tableView: UITableView? {
        return self.view as? UITableView
    }

    // MARK: Initialization

    deinit { cellSnapshot?.removeFromSuperview() }

    // MARK: System Methods

    open func handleGesture() {
        switch self.state {
        case .began:
            guard let trackingIndexPath = (tableView.flatMap {
                (self.location(in:) >>> $0.indexPathForRow(at:))($0)
            }), (tableView.flatMap {
                $0.dataSource?.tableView?($0, canMoveRowAt: trackingIndexPath)
            } ?? false) else { return }

            let cell = tableView?.cellForRow(at: trackingIndexPath)?.then {
                $0.alpha = 1
                $0.isHidden = false
            }

            sourceIndexPath = trackingIndexPath

            cellSnapshot = cell?.customSnapshotView()?.then {
                $0.backgroundColor = .blue
                $0.frame = tableView?.convert(cell?.frame ?? .zero, to: nil) ?? .zero
                $0.alpha = 0
                $0.clipsToBounds = false
                $0.layer.shadowOffset = .zero
                $0.layer.shadowRadius = 3
                $0.layer.shadowOpacity = 0.2
            }.then {
                UIApplication.shared.keyWindow?.addSubview($0)
            }

            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                cell?.alpha = 0

                self.cellSnapshot?.then {
                    $0.alpha = 0.93
                    $0.center.y = self.location(in: nil).y
                    $0.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
                }
                }, completion: { [weak cell] _ in
                    cell?.isHidden = true
                })
        case .changed:
            guard let trackingIndexPath = (tableView.flatMap {
                (self.location(in:) >>> $0.indexPathForRow(at:))($0)
            }), (tableView.flatMap {
                $0.dataSource?.tableView?($0, canMoveRowAt: trackingIndexPath)
            } ?? false) else { return }

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
            self.sourceIndexPath = trackingIndexPath
        default:
            guard let sourceIndexPath = self.sourceIndexPath else { return }

            let cell = tableView?.cellForRow(at: sourceIndexPath)?.then {
                $0.alpha = 0
                $0.isHidden = false
            }

            UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: .calculationModeLinear, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.cellSnapshot?.then {
                        $0.center.y = self.tableView?.convert(cell?.center ?? .zero, to: nil).y ?? 0
                        $0.transform = CGAffineTransform.identity
                    }
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
                    cell?.alpha = 1
                    self.cellSnapshot?.alpha = 0
                }
                }, completion: { [weak self] _ in
                    self?.cellSnapshot?.removeFromSuperview()
                    self?.sourceIndexPath = nil
            })
        }
    }
}
