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
    var cornerRadius: CGFloat = 20
    var blurAlpha: CGFloat = 0.011 // for UITapGestureRecognizer
}

// MARK: - Popup Presentation Controller

class ABPopupPresentationController: UIPresentationController {
    var params: ABPopupPresentationControllerParams
    let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        params: ABPopupPresentationControllerParams = .init()
    ) {
        self.params = params

        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(
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
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate { [weak self] _ in
            self?.blurEffectView.alpha = self?.params.blurAlpha ?? 0
        }
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { [weak self] _ in
                self?.blurEffectView.alpha = 0
            },
            completion: { [weak self] _ in
                self?.blurEffectView.removeFromSuperview()
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
        blurEffectView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
