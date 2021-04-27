//
//  HomeHeaderView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var balance: BalanceProfileButton!
    @IBOutlet private weak var searchBar: UISearchBar!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    func setupUI() {
        setBackgorundColor(to: .primaryBg())
        setupBalance()
        setupSearchBar()
    }

    private func setupBalance() {
        balance.setFont(to: .footnote(fontCase: .upper, fontStyle: .semiBold))
        balance.setTitleColor(to: .primaryText(), for: .normal)
        balance.setTintColor(to: .primaryText())
        balance.setImage(R.image.shared.navBar.profile()?.resizeImage(newHeight: 20), for: .normal)
        balance.semanticContentAttribute = .forceRightToLeft
        balance.titleEdgeInsets = UIEdgeInsets(top: 4, left: -8, bottom: 0, right: 0)
        balance.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }

    private func setupSearchBar() {
        for item in searchBar.searchTextField.subviews where item.className == "_UISearchBarSearchFieldBackgroundView" {
            item.removeAllSubViews()
        }

        searchBar.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .search)
        searchBar.backgroundColor = .clear
        searchBar.barTintColor = .clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        searchBar.setImage(R.image.shared.search(), for: .search, state: .normal)
        searchBar.searchTextField.leftView?.setTintColor(to: .secondaryText())
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 4, vertical: 0)

        searchBar.searchTextField.setTextColor(to: .primaryText())
        searchBar.searchTextField.setFont(to: .footnote(fontCase: .lower))
        searchBar.searchTextField.setBackgorundColor(to: .querternaryFill())
        searchBar.searchTextField.layer.cornerRadius = 18
        searchBar.searchTextField.layer.masksToBounds = true

        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: R.string.localization.home_search_placeholder.localized(), attributes: [
            .foregroundColor: DesignSystem.Color.secondaryText().value,
            .font: DesignSystem.Typography.footnote(fontCase: .lower).description.font
        ])

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = R.string.localization.cancel.localized()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: DesignSystem.Color.secondaryText().value,
            .font: DesignSystem.Typography.footnote(fontCase: .lower).description.font
        ], for: .normal)

        searchBar.delegate = self

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
}

extension HomeHeaderView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
