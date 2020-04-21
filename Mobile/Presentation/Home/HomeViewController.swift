//
//  HomeViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var floatingTabBarManager = FloatingTabBarManager(viewController: self)

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.setBackgorundColor(to: .neutral800)
        setLeftBarButtonItemTitle(to: R.string.localization.home_page_title.localized())
        setupAuthButtonActions()

//        setupScrollView()
        setupCollectionViewController()
    }

    private func setupCollectionViewController() {
        let vc = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.isTabBarManagementEnabled = true

        add(child: vc)

        let played: AppCellDataProviders = (1...20).map {
            let params = PlayedGameLauncherComponentViewModelParams(id: "id", coverUrl: URL(string: "https://google.com")!, name: "Game name \($0)", lastWon: "last won $ \($0)")
            let viewModel = DefaultPlayedGameLauncherComponentViewModel(params: params)
            viewModel.action.subscribe(onNext: { [weak self] action in
                self?.didReceive(action: action)
            }).disposed(by: disposeBag)
            return viewModel
        }

        let items: AppCellDataProviders = (1...20).map {
            let params = GameLauncherComponentViewModelParams(id: "id", coverUrl: URL(string: "https://google.com")!, name: "Game name \($0)", category: "game category \($0)")
            let viewModel = DefaultGameLauncherComponentViewModel(params: params)
            viewModel.action.subscribe(onNext: { [weak self] action in
                self?.didReceive(action: action)
            }).disposed(by: disposeBag)
            return viewModel
        }

        vc.dataProvider = (played + items).makeList()
    }

    private func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.pinSafely(in: view)
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 3)

        floatingTabBarManager.observe(scrollView: scrollView)
    }

    private func setupAuthButtonActions() {
        let items = setAuthBarButtonItems()

        items.joinNow.button.addTarget(self, action: #selector(joinNowButtonDidTap), for: .touchUpInside)
        items.login.button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
    }

    private func setupProfilButton() {
        setProfileBarButtonItem(text: "₾ 0.00")
    }
    
    private func didReceive(action: PlayedGameLauncherComponentViewModelOutputAction) {
        switch action {
        case .didSelect(let vm, _):
            let alert = UIAlertController(title: vm.params.name, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default: break
        }
    }

    private func didReceive(action: GameLauncherComponentViewModelOutputAction) {
        switch action {
        case .didSelect(let vm, _):
            let alert = UIAlertController(title: vm.params.name, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default: break
        }
    }

    @objc public func joinNowButtonDidTap() {
        print(#function)
        let alert = UIAlertController(title: R.string.localization.join_now.localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc public func loginButtonDidTap() {
        print(#function)
        let alert = UIAlertController(title: R.string.localization.login.localized(), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: CommonBarButtonProviding { }
