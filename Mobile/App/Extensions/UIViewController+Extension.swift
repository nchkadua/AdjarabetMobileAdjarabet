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
        view.setBackgorundColor(to: .neutral800())
    }

    func setupStandardSearchViewController(searchController: UISearchController) {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 4, vertical: 0)
        searchController.searchBar.placeholder = R.string.localization.home_search_placeholder.localized()
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true

        searchController.searchBar.setImage(R.image.shared.search(), for: .search, state: .normal)
        searchController.searchBar.searchTextField.leftView?.tintColor = DesignSystem.Color.neutral100().value

        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .search)
        searchController.searchBar.backgroundColor = navigationController?.navigationBar.barTintColor

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: DesignSystem.Color.neutral100().value,
            .font: DesignSystem.Typography.p.description.font
        ]

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: DesignSystem.Color.neutral100().value,
            .font: DesignSystem.Typography.p.description.font
        ], for: .normal)

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = R.string.localization.cancel.localized()

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = DesignSystem.Color.neutral700().value

        for item in searchController.searchBar.searchTextField.subviews where item.className == "_UISearchBarSearchFieldBackgroundView" {
            item.removeAllSubViews()
        }

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    func setBackBarButtonItemIfNeeded(width: CGFloat = 26) {
        let button = UIButton()
        button.setImage(R.image.shared.close(), for: .normal)
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(backBarButtonItemDidTap), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc func backBarButtonItemDidTap() {
        if let nav = navigationController {
            if nav.isBeingPresented || (nav.parent != nil && nav.parent!.isBeingPresented) {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
