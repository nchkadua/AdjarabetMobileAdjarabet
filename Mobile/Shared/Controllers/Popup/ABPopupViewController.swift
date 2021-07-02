//
//  ABPopupViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public class ABPopupViewController: ABViewController {
    private var origin: CGPoint?

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(panGestureRecognizerAction)
            )
        )
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if origin == nil { origin = view.frame.origin }
    }

    @objc private func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        // Not allowing the user to drag the view upward
        guard translation.y >= 0, let origin = self.origin else { return }

        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: origin.y + translation.y)

        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = origin
                }
            }
        }
    }

    static func wrapInNav(popup: ABPopupViewController & UIViewControllerTransitioningDelegate) -> UINavigationController {
        let navc = UINavigationController(rootViewController: popup)
        navc.modalPresentationStyle = popup.modalPresentationStyle
        navc.transitioningDelegate = popup
        navc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navc.navigationBar.shadowImage = UIImage()
        navc.navigationBar.isTranslucent = true
        navc.view.backgroundColor = .clear
        navc.setNavigationBarHidden(false, animated: false)
        return navc
    }
}
