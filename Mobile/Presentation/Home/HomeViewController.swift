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

        let played: [PlayedGameLauncherCollectionViewCellDataProvider] = (1...20).map {
            let params = PlayedGameLauncherComponentViewModelParams(
                id: UUID().uuidString,
                coverUrl: imageUrls.randomElement()!,
                name: "Game name \($0)",
                lastWon: Bool.random() ? nil : "Last won $ \(Int.random(in: 5...100))")
            let viewModel = DefaultPlayedGameLauncherComponentViewModel(params: params)
            return viewModel
        }

        let params = RecentlyPlayedComponentViewModelParams(
            id: UUID().uuidString,
            title: "Recentry Played",
            buttonTitle: "View all",
            playedGames: played)
        let recentryPlayed = DefaultRecentlyPlayedComponentViewModel(params: params)
        recentryPlayed.action.subscribe(onNext: { action in
            self.didReceive(action: action)
        }).disposed(by: disposeBag)

        let items: AppCellDataProviders = (1...20).map {
            let params = GameLauncherComponentViewModelParams(
                id: UUID().uuidString,
                coverUrl: imageUrls.randomElement()!,
                name: "Game name \($0)",
                category: "category \($0)",
                jackpotAmount: Bool.random() ? nil : "$ 50,2319.98")
            let viewModel = DefaultGameLauncherComponentViewModel(params: params)
            viewModel.action.subscribe(onNext: { [weak self] action in
                self?.didReceive(action: action)
            }).disposed(by: disposeBag)
            return viewModel
        }

        vc.dataProvider = ([recentryPlayed] + items).makeList()
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

    private func didReceive(action: RecentlyPlayedComponentViewModelOutputAction) {
        switch action {
        case .didSelectPlayedGame(let vm, _):
            let alert = UIAlertController(title: vm.params.name, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        case .didSelectViewAll(let vm):
            print(vm)
            let alert = UIAlertController(title: "View All", message: nil, preferredStyle: .alert)
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

let imageUrls = [
    URL(string: "https://i.pinimg.com/originals/d5/81/8b/d5818bf3b58848ffe17ebcce2343cf43.jpg")!,
    URL(string: "https://i1.wp.com/i.imgur.com/eOtEAB7.jpg?resize=461%2C650&strip=all")!,
    URL(string: "https://i.imgur.com/kX6Bozw.jpeg")!,
    URL(string: "https://terrigen-cdn-dev.marvel.com/content/prod/1x/_msm_card_10.jpg")!,
    URL(string: "https://i.imgur.com/KNe6Bbc.png")!,
    URL(string: "https://static.gamespot.com/uploads/original/43/434805/3237319-fc5_keyart_1495563526.jpg")!,
    URL(string: "https://gs2-sec.ww.prod.dl.playstation.net/gs2-sec/appkgo/prod/CUSA14123_00/3/i_f180912827ec38fab5d408bf23422536a0a4667397883a69f8e8c7e085118398/i/icon0.png")!,
    URL(string: "https://d2skuhm0vrry40.cloudfront.net/2019/articles/2019-02-16-14-03/fifa_19_old_cover.jpg/EG11/resize/375x-1/quality/75/format/jpg")!,
    URL(string: "https://i1.wp.com/batman-news.com/wp-content/uploads/2012/10/PP_360FOB_gm02_100512_tsn.jpg?fit=1526%2C2153&quality=80&strip=info&ssl=1")!,
    URL(string: "https://www.ncnetgroup.co.za/wp-content/uploads/2019/01/battlefield-3-592.jpg")!
]
