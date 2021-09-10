//
//  ABViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class ABViewController: UIViewController, KeyboardListening, UIGestureRecognizerDelegate, NetworkConnectionObserver {
    
    public var disposeBag = DisposeBag()
    var errorThrowing: ErrorThrowing? {
        willSet {
            newValue?.errorObservable.subscribe(onNext: { [weak self] error in
                self?.show(error: error)
            }).disposed(by: disposeBag)
        }
    }

    private lazy var popupError: PopupErrorView = {
        let error: PopupErrorView = .init()
        error.viewModel.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .tapped(let buttonType, let error):
                self.errorThrowing?.errorActionHandler(buttonType: buttonType, error: error)
                self.hidePopupError()
            default: break
            }
        }).disposed(by: disposeBag)
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()

    private lazy var notificationError: (view: NotificationErrorView, constraint: NSLayoutConstraint) = {
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
    
    private lazy var statusMessage: (view: StatusMessageComponentView, viewModel: StatusMessageComponentViewModel) = {
        let view = StatusMessageComponentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewModel: StatusMessageComponentViewModel = DefaultStatusMessageComponentViewModel(params: .init())
        view.setAndBind(viewModel: viewModel)
        view.hide()
        return (view, viewModel)
    }()

    private lazy var loader: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.animationImages = animatedImages(for: "Loader/loader_")
        imageView.animationDuration = 1.2
        imageView.animationRepeatCount = .max
        imageView.image = imageView.animationImages?.first

        return imageView
    }()

    func animatedImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        while let image = UIImage(named: "\(name)\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }

 // private lazy var statusError: StatusErrorView = .init()

    public var keyScrollView: UIScrollView? { nil }
    public private(set) var isKeyboardOpen: Bool = false
    public private(set) var keyboardFrame: CGRect = .zero
    public var additionalBottomContentInset: CGFloat { 0 }
    public var defaultBottomContentInset: CGFloat { 0 }
    public var setInteractivePopGestureRecognizer = true

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()
        guard setInteractivePopGestureRecognizer else {return}
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setupAsNetworkConnectionObserver()
        setupStatusMessage()
    }
    
    private func setupAsNetworkConnectionObserver() {
        NetworkConnectionManager.shared.addObserver(self)
    }
    
    private func setupStatusMessage() {
        view.addSubview(statusMessage.view)
        view.bringSubviewToFront(statusMessage.view)
        
        NSLayoutConstraint.activate([
            statusMessage.view.heightAnchor.constraint(equalToConstant: Constants.statusMessageViewHeight),
            statusMessage.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statusMessage.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusMessage.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoading()
    }

    public func startLoading() {
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.widthAnchor.constraint(equalToConstant: 80),
            loader.heightAnchor.constraint(equalToConstant: 80),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loader.startAnimating()
    }

    public func stopLoading() {
        loader.stopAnimating()
        loader.removeFromSuperview()
    }

    func show(error: ABError) {
        switch error.description {
        case .popup(let description):
            showPopupError(error: error, description: description)
        case .notification(let description):
            showNotificationError(with: description)
        case .status(let description):
            showStatusError(with: description)
        }
    }

    func showPopupError(error: ABError, description: ABError.Description.Popup) {
        popupError.viewModel.set(error: error, description: description)
        DispatchQueue.main.async { self.showPopupError() }
    }

    func showNotificationError(with description: ABError.Description.Notification) {
        notificationError.view.configure(from: description)
        DispatchQueue.main.async { self.showNotificationError() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.hideNotificationError() }
    }

    func showStatusError(with description: ABError.Description.Status) {
        showAlert(title: "Status: \(description.description)")
    }

    private func showPopupError() {
        view.addSubview(popupError)
        popupError.pin(to: view)
        UIView.animate(
            withDuration: 0.25,
            animations: { self.popupError.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) },
            completion: { _ in
                UIView.animate(withDuration: 0.25) { self.popupError.transform = CGAffineTransform.identity }
            }
        )
    }

    func hidePopupError() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.popupError.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.25,
                    animations: { self.popupError.transform = CGAffineTransform.identity },
                    completion: { _ in self.popupError.removeFromSuperview() }
                )
            }
        )
    }

    private func showNotificationError() {
        notificationError.constraint.constant -= 114
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideNotificationError() {
        notificationError.constraint.constant += 114
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
    
    // MARK: - NetworkConnectionObserver -
    
    var networkConnectionObserverId: Int = NetworkConnectionManager.shared.newObserverId
    
    func networkConnectionEstablished() {
        print("*** networkConnectionEstablished in \(Self.description()))")
        statusMessage.viewModel.type = .connectionEstablished
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tryMoveDownTabBar(by: Constants.statusMessageViewHeight, isAnimated: true)
        }
    }
    
    func networkConnectionLost() {
        print("*** networkConnectionLost in \(Self.description())")
        tryMoveUpTabBar(by: Constants.statusMessageViewHeight, isAnimated: true)
        statusMessage.viewModel.type = .connectionFailed
    }
    
    public func tryMoveUpTabBar(by height: CGFloat, isAnimated: Bool) {
        guard height > 0 else { return }
        guard let tabBarViewController = mainTabBarViewController else { return }
        tabBarViewController.tabBarMovementSemaphore.wait()
        print("*** ----- crossed waiting in move up ----- ")
        
        if tabBarViewController.tabBarPosition == .normal {
            tabBarViewController.tabBarPosition = .movedUp
            print("---------------------- MOVED UP")
            moveTabBarVertically(by: -height, isAnimated: isAnimated)
        }

        tabBarViewController.tabBarMovementSemaphore.signal()
        print("*** ----- crossed signal in move up ----- ")
    }
    
    public func tryMoveDownTabBar(by height: CGFloat, isAnimated: Bool) {
        guard height > 0 else { return }
        guard let tabBarViewController = mainTabBarViewController else { return }

        tabBarViewController.tabBarMovementSemaphore.wait()
        if tabBarViewController.tabBarPosition == .movedUp {
            tabBarViewController.tabBarPosition = .normal
            moveTabBarVertically(by: height, isAnimated: isAnimated)
        }
        tabBarViewController.tabBarMovementSemaphore.signal()
    }
    
    private func moveTabBarVertically(by height: CGFloat, isAnimated: Bool) {
        print("*** moveTabBarVertically(by \(height), isAnimated: Bool) {")
        guard let tabBar = mainTabBarViewController?.tabBar else { return }
        let animationDuration: Double = isAnimated ? 0.5 : 0
        UIView.animate(withDuration: animationDuration, animations: {
            tabBar.frame.origin.y += height
        })
    }
}

extension ABViewController {
    struct Constants {
        static let statusMessageViewHeight: CGFloat = 30
    }
}
