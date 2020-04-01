class WelcomeViewController: UIViewController {
    @IBOutlet private var userIdLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var sessionIdLabel: UILabel!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var amountSuggestionsLabel: UILabel!

    @IBOutlet private var logoutButton: LoadingButton!

    @Inject public var adjarabetCoreClient: AdjarabetCoreServices
    @Inject public var adjarabetWebAPIServices: AdjarabetWebAPIServices

    private let userSession: UserSessionServices = UserSession.current

    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)

        getBalance()
        getFeed()
        setupUI()
    }

    private func setupUI() {
        guard
            let userId = userSession.userId,
            let username = userSession.username,
            let sessionId = userSession.sessionId else {
            return
        }

        userIdLabel.text = "\(userId)"
        usernameLabel.text = username
        sessionIdLabel.text = sessionId
    }

    @objc private func logoutButtonDidTap() {
        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}
        logoutButton.showLoading()

        adjarabetCoreClient.logout(userId: userId, sessionId: sessionId) { (result: Result<AdjarabetCoreResult.Logout, Error>) in
            defer {
                self.logoutButton.hideLoading()
            }

            switch result {
            case .success(let value):
                print(value)
                self.userSession.clear()
                self.navigateToLoginPage()
            case .failure(let error):
                if error.isSessionNotFound {
                    self.userSession.clear()
                    self.navigateToLoginPage()
                }
                print(error.localizedDescription)
            }
        }
    }

    private func getBalance() {
        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}

        adjarabetCoreClient.balance(
            userId: userId,
            currencyId: userSession.currencyId ?? -1,
            isSingle: 0,
            sessionId: sessionId) { (result: Result<AdjarabetCoreResult.Balance, Error>) in
                switch result {
                case .success(let value):
                    print(value)
                    self.balanceLabel.text = "\(value.codable.balanceAmount / 100)"
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }

    private func getFeed() {
        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}

        adjarabetWebAPIServices.userLoggedIn(userId: userId, domain: ".com", sessionId: sessionId) { (result: Result<AdjarabetWebAPICodable.UserLoggedIn, Error>) in
            switch result {
            case .success(let codable):
                print(codable)
                self.amountSuggestionsLabel.text = codable.data.amountSuggestions.map { "\($0)₾" }.joined(separator: " - ")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func navigateToLoginPage() {
        UIApplication.shared.currentWindow?.rootViewController = R.storyboard.login().instantiate(controller: LoginViewController.self)?.wrapInNav()
    }
}
