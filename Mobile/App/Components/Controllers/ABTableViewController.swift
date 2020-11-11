//
//  ABTableViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol ABTableViewControllerDelegate: class {
    func didDeleteCell(at indexPath: IndexPath)
}

public class ABTableViewController: AppTableViewController {
    public weak var delegate: ABTableViewControllerDelegate?
    private let disposeBag = DisposeBag()
    public var isTabBarManagementEnabled: Bool = false
    public var canEditRow: Bool = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(types: [
            PromotionTableViewCell.self,
            NotificationTableViewCell.self,
            NotificationsHeaderCell.self
        ])

        setupTableView()
    }

    private func setupTableView () {
        tableView.backgroundColor = .clear
    }

    // MARK: TabBar management
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performCheck(for: translation)
    }

    public override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetPoint = targetContentOffset.pointee
        let currentPoint = scrollView.contentOffset

        if targetPoint.y > currentPoint.y {
            hideFloatingTabBar()
        } else {
            showFloatingTabBar()
        }
    }

    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        performCheck(for: translation)
    }

    public func performCheck(for translation: CGPoint) {
        if translation.y >= 0 {
            showFloatingTabBar()
        } else {
            hideFloatingTabBar()
        }
    }

    public func hideFloatingTabBar() {
        guard isTabBarManagementEnabled else {return}
        mainTabBarViewController?.hideFloatingTabBar()
    }

    public func showFloatingTabBar() {
        guard isTabBarManagementEnabled else {return}
        mainTabBarViewController?.showFloatingTabBar()
    }

    // MARK: Deletable Cell Management
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard !(tableView.cellForRow(at: indexPath) is NotificationsHeaderCell) else { return false }
        return canEditRow
    }

    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            (self.dataProvider?[indexPath] as? AppDeletableCellDelegate)?.didDelete(at: indexPath)
        }
        deleteItem.image = R.image.notifications.trash()
        deleteItem.backgroundColor = R.color.colorGuide.systemTints.systemRed()
        let actions = UISwipeActionsConfiguration(actions: [deleteItem])

        return actions
    }
}

public extension AppTableViewController {
    func reloadItems(items: AppCellDataProviders = [], insertionIndexPathes: [IndexPath] = [], deletionIndexPathes: [IndexPath] = []) {
        tableView.performBatchUpdates({
            deletionIndexPathes.reversed().forEach {
                dataProvider?.sectionDataProviders[$0.section].remove(at: $0.item)
            }
            tableView?.deleteRows(at: deletionIndexPathes, with: .automatic)

            if let first = insertionIndexPathes.first {
                items.reversed().forEach {
                    dataProvider?.sectionDataProviders[first.section].insert($0, at: first.item)
                }
                tableView?.insertRows(at: insertionIndexPathes, with: .automatic)
            }
        }, completion: nil)
    }
}
