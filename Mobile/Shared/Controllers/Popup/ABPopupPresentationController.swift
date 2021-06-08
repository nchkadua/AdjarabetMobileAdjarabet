//
//  ABPopupPresentationController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

// MARK: - Popup Presentation Controller Params

struct ABPopupPresentationControllerParams {
    var heightMultiplier: CGFloat = 0
    var heightConstant: CGFloat = 0
    // Optional Configuration:
    var cornerRadius: CGFloat = 20
}

// MARK: - Popup Presentation Controller

class ABPopupPresentationController: UIPresentationController {
    var params: ABPopupPresentationControllerParams

    private let backgroundView: UIView
    private let backgroungColor: UIColor = UIColor.black.withAlphaComponent(0.5)

    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        params: ABPopupPresentationControllerParams = .init()
    ) {
        self.params = params
        self.backgroundView = UIView()

        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )

        backgroundView.backgroundColor = backgroungColor
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissController)
            )
        )
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let height = containerView!.frame.height * params.heightMultiplier + params.heightConstant
        return CGRect(
            origin: CGPoint(x: 0, y: containerView!.frame.height - height),
            size: CGSize(
                width: containerView!.frame.width,
                height: height
            )
        )
    }

    override func presentationTransitionWillBegin() {
        backgroundView.backgroundColor = .clear
        containerView?.addSubview(backgroundView)
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.backgroundView.backgroundColor = self?.backgroungColor
        }
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                self?.backgroundView.backgroundColor = .clear
            },
            completion: { [weak self] _ in
                self?.backgroundView.removeFromSuperview()
            }
        )
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.roundCorners([.topLeft, .topRight], radius: params.cornerRadius)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
