//
//  ABTableViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol ABTableViewControllerDelegate: AnyObject {
    func didDeleteCell(at indexPath: IndexPath)
    func didLoadNextPage()
    func redraw(at indexPath: IndexPath)
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
            NotificationsHeaderCell.self,
            TransactionHistoryTableViewCell.self,
            DateHeaderCell.self,
            TransactionDetailsTableViewCell.self,
            TransactionFilterTableViewCell.self,
            AccountParametersTableViewCell.self,
            AccountSecurityMessagesTableViewCell.self,
            AccountParametersHeaderTableViewCell.self,
            AccessHistoryTableViewCell.self,
            SecurityLevelTableViewCell.self,
            SecurityLevelTypeTableViewCell.self,
            MyCardTableViewCell.self,
            AddMyCardTableViewCell.self,
            VideoCardTableViewCell.self,
            CloseAccountButtonTableViewCell.self
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

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 10 is max items per page
        if tableView.numberOfSections - 1 == indexPath.section && tableView.numberOfRows(inSection: indexPath.section) - 10 == indexPath.item {
            delegate?.didLoadNextPage()
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
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
        return  // Floating tab bar removed
        // guard isTabBarManagementEnabled else {return}
        // mainTabBarViewController?.hideFloatingTabBar()
    }

    public func showFloatingTabBar() {
        return  // Floating tab bar removed
        // guard isTabBarManagementEnabled else {return}
        // mainTabBarViewController?.showFloatingTabBar()
    }

    // MARK: Deletable Cell Management
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        guard cell is EditableCell else { return false }
        return canEditRow
    }

    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .destructive, title: R.string.localization.notifications_page_delete_title.localized()) { _, _, _ in
            (self.dataProvider?[indexPath] as? AppDeletableCellDelegate)?.didDelete(at: indexPath)
        }
        deleteItem.image = R.image.notifications.trash()
        deleteItem.backgroundColor = R.color.colorGuide.systemTints.systemRed()
        let actions = UISwipeActionsConfiguration(actions: [deleteItem])

        return actions
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (self.dataProvider?[indexPath] as? AppRedrawableCellDelegate)?.redraw(at: indexPath)
    }
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
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

    func reloadWithAnimation(_ animation: UITableView.RowAnimation = .bottom) {
        let range = NSRange(location: 0, length: tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        tableView.reloadSections(sections as IndexSet, with: animation)
    }
}
