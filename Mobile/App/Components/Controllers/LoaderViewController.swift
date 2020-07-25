//
//  LoaderViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/4/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class LoaderViewController: UIViewController {
    public lazy var activityView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.tintColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.hidesWhenStopped = true
        return v
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = nil
        view.addSubview(activityView)
        activityView.pin(to: view)
    }

    public func set(isLoading: Bool) {
        isLoading ? activityView.startAnimating() : activityView.stopAnimating()
        view.isHidden = !isLoading
    }
}
