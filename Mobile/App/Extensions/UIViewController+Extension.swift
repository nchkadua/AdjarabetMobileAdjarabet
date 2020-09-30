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
        view.setBackgorundColor(to: .systemGray200())
    }

    func setupStandardSearchViewController(_ searchController: UISearchController) {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    func setBackBarButtonItemIfNeeded(width: CGFloat = 26) {
        let button = UIButton()
        button.setImage(R.image.shared.back(), for: .normal)
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
}
