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
    @IBOutlet private weak var logo: UIImageView!
    @IBOutlet private weak var balance: BalanceProfileButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private var smallStyleConstraints: [NSLayoutConstraint]!
    @IBOutlet private var largeStyleConstraints: [NSLayoutConstraint]!
    @IBOutlet private var focusStyleConstraints: [NSLayoutConstraint]!

    // state
    private var prevStyle: Style = .large  // by default
    private var currStyle: Style = .large  // large style is set

    weak var delegate: HomeHeaderViewDelegate?
    var bar: UISearchBar { searchBar }
    var balanceButton: BalanceProfileButton { balance }

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    private enum Style {
        case small
        case large
        case focus
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
        set(style: .large)
        setupBalance()
        setupSearchBar()
        setupAccessibilityIdentifiers()
    }

    func scrolledUp() {
        if currStyle != .focus {
            set(style: .large)
        }
    }

    func scrolledDown() {
        if currStyle != .focus {
            set(style: .small)
        }
    }

    private func set(style: Style) {
        // update state
        prevStyle = currStyle
        currStyle = style
        // update constraints
        let balanceIsHiden: Bool
        switch style {
        case .small:
            focusStyleConstraints.forEach { $0.priority = .defaultLow }
            largeStyleConstraints.forEach { $0.priority = .defaultLow }
            smallStyleConstraints.forEach { $0.priority = .required }
            balanceIsHiden = false
        case .large:
            focusStyleConstraints.forEach { $0.priority = .defaultLow }
            smallStyleConstraints.forEach { $0.priority = .defaultLow }
            largeStyleConstraints.forEach { $0.priority = .required }
            balanceIsHiden = false
        case .focus:
            smallStyleConstraints.forEach { $0.priority = .defaultLow }
            largeStyleConstraints.forEach { $0.priority = .defaultLow }
            focusStyleConstraints.forEach { $0.priority = .required }
            balanceIsHiden = true
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.balance.alpha = balanceIsHiden ? 0 : 1
            self?.layoutIfNeeded()
            self?.superview?.layoutIfNeeded()
        }
    }

    private func focus() {
        set(style: .focus)
        searchBar.setShowsCancelButton(true, animated: true)
        delegate?.didFocus()
    }

    private func unfocus() {
        set(style: prevStyle)
        prevStyle = currStyle // set prevStyle to the same as currStyle (not to .focus)
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = ""
        delegate?.didUnfocus()
    }

    // MARK: - Initial Setup

    private func setupBalance() {
        balance.setFont(to: .body2(fontCase: .upper, fontStyle: .semiBold))
        balance.setTitleColor(to: .primaryText(), for: .normal)
        balance.setTintColor(to: .primaryText())
        balance.setImage(R.image.shared.navBar.profile()?.resizeImage(newHeight: 24), for: .normal)
        balance.semanticContentAttribute = .forceRightToLeft
        balance.titleEdgeInsets = UIEdgeInsets(top: 4, left: -12, bottom: 0, right: 0)
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
        if searchBar.isFirstResponder { unfocus() }
    }
}

extension HomeHeaderView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        focus()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        unfocus()
    }
}

// MARK: - Delegate
protocol HomeHeaderViewDelegate: AnyObject {
    func didFocus()
    func didUnfocus()
}



extension HomeHeaderView: Accessible {
private func setupAccessibilityIdentifiers() {
    generateAccessibilityIdentifiers()

    searchBar.accessibilityIdentifier = "HomeHeaderView.searchBar"
    searchBar.searchTextField.accessibilityIdentifier = "HomeHeaderView.searchBar.placeholder"
    balance.accessibilityIdentifier = "HomeHeaderView.balance"
}
}
