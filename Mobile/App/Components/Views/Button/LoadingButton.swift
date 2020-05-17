//
//  LoadingButton.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol Loading {
    func showLoading()
    func hideLoading()
}

public class LoadingButton: AppShadowButton, Loading {
    private var originalButtonText: String?

    public lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = tintColor
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        return activityIndicator
    }()

    private func loading(_ isLoading: Bool) {
        isEnabled = !isLoading

        if isLoading {
            originalButtonText = titleLabel?.text
            setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            setTitle(originalButtonText, for: .normal)
            activityIndicator.stopAnimating()
        }
    }

    public func showLoading() {
        loading(true)
    }

    public func hideLoading() {
        loading(false)
    }
}
