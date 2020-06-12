//
//  ABViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class ABViewController: UIViewController, KeyboardListening, UIGestureRecognizerDelegate {
    public var disposeBag = DisposeBag()

    public var keyScrollView: UIScrollView? { nil }
    public private(set) var isKeyboardOpen: Bool = false
    public private(set) var keyboardFrame: CGRect = .zero
    public var additionalBottomContentInset: CGFloat { 0 }
    public var defaultBottomContentInset: CGFloat { 0 }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func addKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    // MARK: KeyboardListening
    public func keyboardWillShow(notification: NSNotification) {
        isKeyboardOpen = true
        keyScrollView?.contentInset.bottom = getKeyboardHeight(notification) + additionalBottomContentInset
    }

    public func keyboardWillHide(notification: NSNotification) {
        isKeyboardOpen = false
        keyScrollView?.contentInset.bottom = defaultBottomContentInset
    }

    public func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardFrameEndUserInfoValue = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        keyboardFrame = keyboardFrameEndUserInfoValue.cgRectValue
    }

    public func keyboardDidChangeFrame(notification: NSNotification) {
    }

    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !(touch.view is UIControl)
    }

    // MARK: Actions
    @objc public func closeKeyboard() {
        view.endEditing(true)
    }
}