//
//  UIViewController+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public extension UIViewController {
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }

            switch view {
            case let scrollView as UIScrollView where scrollView.scrollsToTop:
                let point = CGPoint(x: 0, y: -(view.safeAreaInsets.top + scrollView.contentInset.top))
                scrollView.setContentOffset(point, animated: true)
                return
            default:
                break
            }

            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }

        scrollToTop(view: view)
    }

    func setBaseBackgorundColor() {
        view.setBackgorundColor(to: .neutral800)
    }

    func setupStandardSearchViewController(searchController: UISearchController) {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = R.string.localization.home_search_placeholder.localized()
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.searchTextField.backgroundColor = DesignSystem.Color.neutral700.value

        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .search)
        searchController.searchBar.backgroundColor = navigationController?.navigationBar.barTintColor

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: DesignSystem.Color.neutral100.value,
            .font: DesignSystem.Typography.p.description.font
        ]

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: DesignSystem.Color.neutral100.value,
            .font: DesignSystem.Typography.p.description.font
        ], for: .normal)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }
}
