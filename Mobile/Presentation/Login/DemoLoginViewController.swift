//
//  LoginViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class DemoLoginViewController: UIViewController {
    #if DEVELOPMENT
    let username = "p2p16" //"testpng"
    let password = "Paroli2" //"Paroli1"
    #else
    let username = "shota.io" // "adj_user"
    let password = "Burtiburtibu#1" // "Paroli1"
    #endif

    enum Mode {
        case normal
        case smsCode
    }

    public var mode: Mode = .normal {
        didSet {
            configureUI()
        }
    }

    @IBOutlet private var inputView1: ABInputView!
    @IBOutlet private var inputView2: ABInputView!
    @IBOutlet private var inputView3: ABInputView!

    @IBOutlet private var loginTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var smsCodeTextField: UITextField! {
        didSet {
            if #available(iOS 12.0, *) {
                smsCodeTextField.textContentType = .oneTimeCode
            }
        }
    }

//    @Inject public var adjarabetCoreClient: AdjarabetCoreServices

    @IBOutlet private var loginButton: LoadingButton!
    @IBOutlet private var smsCodeButton: LoadingButton!
    @IBOutlet private var biometryButton: UIButton!

    private let userSession: UserSessionServices = UserSession.current

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Bundle.main.coreAPIUrl.absoluteString
        configureUI()

        loginTextField.text = username
        passwordTextField.text = password

        loginTextField.textContentType = .username
        passwordTextField.textContentType = .password

        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        smsCodeButton.addTarget(self, action: #selector(smsCodeDidTap), for: .touchUpInside)
        biometryButton.addTarget(self, action: #selector(biometryDidTap), for: .touchUpInside)

        setupBiometryButton()

        setBaseBackgorundColor()

        inputView1.setPlaceholder(text: "username")
        inputView1.setTextAndConfigure(text: "Initial text")
        inputView1.setSize(to: .large)

        inputView2.setPlaceholder(text: "password")
        inputView2.setValidation(text: "Error message", color: .error())
        inputView2.setSize(to: .medium)

        inputView3.setPlaceholder(text: "small text title")
        inputView3.setTextAndConfigure(text: "Small text")
        inputView3.setSize(to: .small)
    }

    private func configureUI() {
        setupNavigationItem()
        passwordTextField.isHidden = mode == .smsCode
        smsCodeTextField.isHidden = !passwordTextField.isHidden
    }

    @objc private func closeButtonDidTap() {
        mode = .normal
        passwordTextField.becomeFirstResponder()
    }

    private func setupNavigationItem() {
        let button = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonDidTap))
        navigationItem.rightBarButtonItem = mode == .smsCode ? button : nil
    }

    private func setupBiometryButton() {
//        biometryButton.isHidden = !(UserSession.current.isLoggedIn && Biometry.shared.isAvailable)
//        biometryButton.setImage(Biometry.shared.image, for: .normal)
    }

    @objc private func biometryDidTap() {
//        Biometry.shared.authenticate(onSuccess: {
//            self.getActiveSession()
//        }, onError: { error in
//            print(error?.localizedDescription ?? "")
//        })
    }

    private func getActiveSession() {
//        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}
//
//        loginButton.showLoading()
//
//        adjarabetCoreClient.aliveSession(userId: userId, sessionId: sessionId) { (result: Result<AdjarabetCoreResult.AliveSession, Error>) in
//            defer {
//                self.loginButton.hideLoading()
//            }
//
//            switch result {
//            case .success(let value):
//                print(value)
//                self.navigateToWelcomePage()
//            case .failure(let error):
//                if error.isSessionNotFound {
//                    self.userSession.remove()
//                    UIApplication.shared.currentWindow?.rootViewController = R.storyboard.login().instantiate(controller: LoginViewController.self)?.wrapInNav()
//                }
//                print(error.localizedDescription)
//            }
//        }
    }

    @objc private func smsCodeDidTap() {
//        guard let username = loginTextField.text else {return}
//
//        mode = .smsCode
//
//        smsCodeButton.showLoading()
//        smsCodeTextField.text = nil
//        smsCodeTextField.becomeFirstResponder()
//
//        adjarabetCoreClient.smsCode(username: username, channel: 2) { (result: Result<AdjarabetCoreResult.SmsCode, Error>) in
//            defer {
//                self.smsCodeButton.hideLoading()
//            }
//
//            switch result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }

    @objc private func loginDidTap() {
        switch mode {
        case .normal:
            login()
        case .smsCode:
            loginWithSMSCode()
        }
    }

    private func login() {
//        guard let username = loginTextField.text, let password = passwordTextField.text else {return}
//
//        loginButton.showLoading()
//
//        adjarabetCoreClient.login(username: username, password: password, channel: 0) { (result: Result<AdjarabetCoreResult.Login, Error>) in
//            defer {
//                self.loginButton.hideLoading()
//            }
//
//            switch result {
//            case .success(let value):
//                print(value)
//                UserSession.current.set(
//                    userId: value.codable.userID,
//                    username: value.codable.username,
//                    sessionId: value.header!.sessionId,
//                    currencyId: value.codable.preferredCurrency)
//                UserSession.current.set(isLoggedIn: true)
//                self.navigateToWelcomePage()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }

    private func loginWithSMSCode() {
//        guard let username = loginTextField.text, let code = smsCodeTextField.text else {return}
//
//        loginButton.showLoading()
//        adjarabetCoreClient.login(username: username, code: code, loginType: .sms) { (result: Result<AdjarabetCoreResult.Login, Error>) in
//            defer {
//                self.loginButton.hideLoading()
//            }
//
//            switch result {
//            case .success(let value):
//                print(value)
//                UserSession.current.set(
//                    userId: value.codable.userID,
//                    username: value.codable.username,
//                    sessionId: value.header!.sessionId,
//                    currencyId: value.codable.preferredCurrency)
//                UserSession.current.set(isLoggedIn: true)
//                self.navigateToWelcomePage()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
//
//    private func navigateToWelcomePage() {
//        UIApplication.shared.currentWindow?.rootViewController = R.storyboard.login().instantiate(controller: WelcomeViewController.self)?.wrapInNav()
//    }
}
