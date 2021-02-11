//
//  GameViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import WebKit

public class GameViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: GameViewModel
    public lazy var navigator = GameNavigator(viewController: self)
    
    @IBOutlet weak var gameLoaderView: GameLoaderComponentView!
    
    private lazy var webView: WKWebView = {
        WKWebView()
    }()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: GameViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: GameViewModelOutputAction) {
        switch action {
        case .bindToGameLoader(let viewModel): bindToGameLoader(viewModel)
        }
    }
    
    /// CashFlow Tab
    private func bindToGameLoader(_ gameLoaderViewModel: GameLoaderComponentViewModel) {
        gameLoaderView.setAndBind(viewModel: gameLoaderViewModel)
        bind(to: gameLoaderViewModel)
    }

    private func bind(to viewModel: GameLoaderComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: GameLoaderComponentViewModelOutputAction) {
        switch action {
        case .didBeginAnimation: print("Animation did begin")
        case .didFinishAnimation: print("Animation did finish")
        default:
            break
        }
    }
    
    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupWebView()
    }
    
    private func setupNavigationItems() {
        setTitle(title: "Game")
        setGameBackButton(width: 54)

        let depositButton = makeGameDepositBarButtonItem()
        navigationItem.rightBarButtonItem = depositButton.barButtonItem
        depositButton.button.addTarget(self, action: #selector(openDeposit), for: .touchUpInside)
    }
    
    @objc private func openDeposit() {
        navigator.navigate(to: .deposit, animated: true)
    }
    
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.setValue("TRUE", forKey: "allowUniversalAccessFromFileURLs")
        webView.configuration.preferences.javaScriptEnabled = true

        view.addSubview(webView)
        webView.pinSafely(to: view)
    }
}

extension GameViewController: CommonBarButtonProviding { }

// MARK: - GameViewController Navigation Items
extension GameViewController {
    func setGameBackButton(width: CGFloat = 26) {
        navigationItem.leftBarButtonItems?.removeAll()
        
        let button = UIButton()
        button.setImage(R.image.game.back(), for: .normal)
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(dismissGameView), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc func dismissGameView() {
        dismiss(animated: true, completion: nil)
    }
}
