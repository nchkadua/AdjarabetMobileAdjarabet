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

     private lazy var v: UIView = {
          return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
     }() ?? view

     private lazy var popupBgView: UIView = {
          let bg = UIView(frame: CGRect(x: 0, y: 0, width: v.frame.width, height: v.frame.height))
          bg.setBackgorundColor(to: .primaryBg(alpha: 0.5))
          bg.alpha = 0.0

          return bg
     }()

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

          v.addSubview(error)
          error.translatesAutoresizingMaskIntoConstraints = false

          let constraint = error.topAnchor.constraint(equalTo: v.bottomAnchor)
          NSLayoutConstraint.activate([
               constraint,
               error.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 23),
               error.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -23),
               error.heightAnchor.constraint(equalToConstant: 84)
          ])

          return (error, constraint)
     }()

     //Success
     private lazy var successBg: UIView = {
          let bg = UIImageView(frame: CGRect(x: view.bounds.origin.x / 2, y: view.bounds.origin.y / 2, width: 72, height: 72))
          bg.translatesAutoresizingMaskIntoConstraints = false
          bg.setBackgorundColor(to: .primaryText())
          bg.layer.cornerRadius = 13

          return bg
     }()

     private lazy var success: UIImageView = {
          let imageView = UIImageView()
          imageView.translatesAutoresizingMaskIntoConstraints = false

          imageView.animationImages = animatedImages(for: "Success/Success_")
          imageView.animationDuration = 2.38
          imageView.animationRepeatCount = 1
          imageView.image = imageView.animationImages?.first

          return imageView
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
     }

     private func setupAsNetworkConnectionObserver() {
          NetworkConnectionManager.shared.addObserver(self)
     }

     public override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          stopLoading()
     }

     public func showSuccess(completion: @escaping () -> Void) {
          guard !success.isAnimating else {return}

          view.addSubview(successBg)
          successBg.alpha = 0.0
          NSLayoutConstraint.activate([
               successBg.widthAnchor.constraint(equalToConstant: 96),
               successBg.heightAnchor.constraint(equalToConstant: 96),
               successBg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               successBg.centerYAnchor.constraint(equalTo: view.centerYAnchor)
          ])

          successBg.addSubview(success)
          NSLayoutConstraint.activate([
               success.widthAnchor.constraint(equalToConstant: 86),
               success.heightAnchor.constraint(equalToConstant: 86),
               success.centerXAnchor.constraint(equalTo: successBg.centerXAnchor),
               success.centerYAnchor.constraint(equalTo: successBg.centerYAnchor)
          ])
          //
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.19) { [self] in
               UIView.animate(withDuration: 0.4, animations: {
                    self.successBg.alpha = 0.0
               }, completion: { _ in
                    self.success.stopAnimating()
                    self.successBg.removeFromSuperview()
                    self.success.removeFromSuperview()

                    completion()
               })
          }

          DispatchQueue.main.asyncAfter(deadline: .now() + 0.145) { SoundPlayer.shared.playSound("success") }
          UIView.animate(withDuration: 0.5, animations: {
               self.successBg.alpha = 1.0
          })
          self.success.startAnimating()
     }

     public func startLoading() {
          guard !loader.isAnimating else {return}

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
          guard loader.isAnimating else {return}

          loader.stopAnimating()
          loader.removeFromSuperview()
     }

     func show(error: ABError) {
          stopLoading()
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

     private var isNotificationErrorShown = false
     func showNotificationError(with description: ABError.Description.Notification) {
          guard !isNotificationErrorShown else { return }

          notificationError.view.configure(from: description)
          DispatchQueue.main.async { self.showNotificationError() }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.hideNotificationError() }
     }

     func showStatusError(with description: ABError.Description.Status) {
          showAlert(title: "Status: \(description.description)")
     }

     private func showPopupError() {
          v.addSubview(popupBgView)
          v.addSubview(popupError)
          popupError.pin(to: v)
          self.popupError.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

          UIView.animate(
               withDuration: 0.2,
               animations: {
                    self.popupBgView.alpha = 1.0
                    UIView.animate(withDuration: 0.25) { self.popupError.transform = CGAffineTransform.identity }
               }
          )

          UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
     }

     func hidePopupError() {
          UIView.animate(
               withDuration: 0.15,
               animations: {
                    self.popupBgView.alpha = 0.0
                    self.popupError.alpha = 0.0
                    self.popupError.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
               },
               completion: { _ in
                    self.v.addSubview(self.popupBgView)
                    self.popupError.removeFromSuperview()
               }
          )
     }

     private func showNotificationError() {
          notificationError.constraint.constant -= 114
          UIView.animate(withDuration: 0.5) {
               self.v.layoutIfNeeded()
          }
          isNotificationErrorShown = true
     }

     private func hideNotificationError() {
          notificationError.constraint.constant += 114
          UIView.animate(withDuration: 0.5) {
               self.v.layoutIfNeeded()
          }
          isNotificationErrorShown = false
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

     // MARK: - NetworkConnectionObserver

     internal var networkConnectionObserverId: Int = NetworkConnectionManager.shared.newObserverId

     public func networkConnectionEstablished() {
		DispatchQueue.main.async {
			self.show(error: .init(type: .`init`(description: .notification(description: .init(icon: Constants.InternetConnectionStatus.connectionEstablished.icon, description: Constants.InternetConnectionStatus.connectionEstablished.description)))))
		}
     }

	public func networkConnectionLost() {
		DispatchQueue.main.async {
			self.show(error: .init(type: .`init`(description: .notification(description: .init(icon: Constants.InternetConnectionStatus.connectionLost.icon, description: Constants.InternetConnectionStatus.connectionLost.description)))))
		}
	}

	private func setupNetworkConnectionState() {
		if !NetworkConnectionManager.shared.isConnected {
			DispatchQueue.main.async {
				self.show(error: .init(type: .`init`(description: .notification(description: .init(icon: Constants.InternetConnectionStatus.connectionLost.icon, description: Constants.InternetConnectionStatus.connectionLost.description)))))
			}
		}
	}
}

extension ABViewController {
	struct Constants {
		enum InternetConnectionStatus {
			case connectionLost
			case connectionEstablished
			
			var icon: UIImage {
				switch self {
				case .connectionLost: return R.image.shared.connectionLost()!
				case .connectionEstablished: return R.image.shared.connectionEstablished()!
				}
			}
			
			var description: String {
				switch self {
				case .connectionLost: return R.string.localization.status_message_internet_connection_lost.localized()
				case .connectionEstablished: return R.string.localization.status_message_internet_connection_established.localized()
				}
			}
	   }
	}
}
