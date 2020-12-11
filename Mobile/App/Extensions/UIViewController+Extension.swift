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

    func setBaseBackgorundColor(to color: DesignSystem.Color = .secondaryBg()) {
        view.setBackgorundColor(to: color)
    }

    func setupStandardSearchViewController(_ searchController: UISearchController) {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    func setTitle(title: String) {
        let label = UILabel()
        label.text = title
        label.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        label.setTextColor(to: .primaryText())
        navigationItem.titleView = label
    }

    func setBackBarButtonItemIfNeeded(width: CGFloat = 26, rounded: Bool = false) {
        navigationItem.leftBarButtonItems?.removeAll()
        let button = UIButton()

        if rounded {
            button.setImage(R.image.login.sms_back(), for: .normal)
        } else {
            button.setImage(R.image.shared.back(), for: .normal)
        }

        button.setTintColor(to: .secondaryFill())
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

    func setDismissBarButtonItemIfNeeded(width: CGFloat = 26) {
        setDismissBarButtonItemIfNeededHelper(width: width, icon: R.image.shared.close())
    }

    func setBackDismissBarButtonItemIfNeeded(width: CGFloat = 26) {
        setDismissBarButtonItemIfNeededHelper(width: width, icon: R.image.shared.back())
    }

    private func setDismissBarButtonItemIfNeededHelper(width: CGFloat, icon: UIImage?) {
        navigationItem.leftBarButtonItems?.removeAll()
        let button = UIButton()
        button.setImage(icon, for: .normal)
        button.setTintColor(to: .secondaryFill())
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(dismissBarButtonItemDidTap), for: .touchUpInside)
        let dismissBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = dismissBarButtonItem
    }

    @objc func dismissBarButtonItemDidTap() {
        if let nav = navigationController {
            guard nav.topViewController?.parent != nil else { return }

            dismiss(animated: true, completion: nil)
        }
    }

    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
    }

    @discardableResult
    func addDefaultLoader() -> LoaderViewController {
        let vc = LoaderViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        add(child: vc)
        vc.view.pin(to: view)
        return vc
    }

    @discardableResult
    func addDefaultGamesListLoader(isRecentlyPlayedEnabled: Bool) -> GamesListLoader {
        let v = GamesListLoader(isRecentlyPlayedEnabled: isRecentlyPlayedEnabled)
        v.backgroundColor = view.backgroundColor
        v.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v)
        v.pin(to: view)
        return v
    }

    func wrapInNavWith(presentationStyle: UIModalPresentationStyle = .automatic) -> UINavigationController {
        let navC = UINavigationController(rootViewController: self)
        navC.modalPresentationStyle = presentationStyle

        return navC
    }

    func hideNavBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: { [weak self] in
            self?.navigationController?.setNavigationBarHidden(true, animated: true)
        }, completion: nil)
    }

    func showNavBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: { [weak self] in
            self?.navigationController?.setNavigationBarHidden(false, animated: true)
        }, completion: nil)
    }
}
