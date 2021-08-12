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
    var errorThrowing: ErrorThrowing? {
        willSet {
            newValue?.errorObservable.subscribe(onNext: { [weak self] error in
                self?.show(error: error)
            }).disposed(by: disposeBag)
        }
    }

 // private lazy var popupError: PopupErrorView = .init()

    private lazy var notificationError: (view: NotificationErrorView, constraint: NSLayoutConstraint)  = {
        let error: NotificationErrorView = .init()

        view.addSubview(error)
        error.translatesAutoresizingMaskIntoConstraints = false

        let constraint = error.topAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            constraint,
            error.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            error.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
            error.heightAnchor.constraint(equalToConstant: 84)
        ])

        return (error, constraint)
    }()

 // private lazy var statusError: StatusErrorView = .init()

    public var keyScrollView: UIScrollView? { nil }
    public private(set) var isKeyboardOpen: Bool = false
    public private(set) var keyboardFrame: CGRect = .zero
    public var additionalBottomContentInset: CGFloat { 0 }
    public var defaultBottomContentInset: CGFloat { 0 }

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func show(error: ABError) {
        switch error.description {
        case .popup(let description):
            showPopupError(with: description)
        case .notification(let description):
            showNotificationError(with: description)
        case .status(let description):
            showStatusError(with: description)
        }
    }

    func showPopupError(with description: ABError.Description.Popup) {
        showAlert(title: "Popup: \(description.description)")
    }

    func showNotificationError(with description: ABError.Description.Notification) {
        notificationError.view.configure(from: description)
        DispatchQueue.main.async {
            self.notificationError.constraint.constant -= 114
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.notificationError.constraint.constant += 114
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func showStatusError(with description: ABError.Description.Status) {
        showAlert(title: "Status: \(description.description)")
    }

    public func addKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    public func setupKeyboard() {
        observeKeyboardNotifications()
        addKeyboardDismissOnTap()
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

    public func setMainContainerSwipeEnabled(_ enabled: Bool) {
        if let vc = UIApplication.shared.currentWindow?.rootViewController as? MainContainerViewController {
            vc.setPageViewControllerSwipeEnabled(enabled)
        }
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
