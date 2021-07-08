//
//  KeyboardListening.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@objc public protocol KeyboardListening: AnyObject {
    var keyScrollView: UIScrollView? { get }
    var isKeyboardOpen: Bool { get }
    var keyboardFrame: CGRect { get }
    var additionalBottomContentInset: CGFloat { get }
    var defaultBottomContentInset: CGFloat { get }

    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
    func keyboardWillChangeFrame(notification: NSNotification)
    func keyboardDidChangeFrame(notification: NSNotification)
}

public extension KeyboardListening where Self: UIViewController {
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardFrameEndUserInfoValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return 0}
        let keyboardFrame = keyboardFrameEndUserInfoValue.cgRectValue
        return keyboardFrame.size.height
    }

    func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector:
            #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidChangeFrame),
            name: UIResponder.keyboardDidChangeFrameNotification,
            object: nil)
    }
}
