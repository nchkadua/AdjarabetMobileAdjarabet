//
//  MyBonusesViewController.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class MyBonusesViewController: UIViewController {
	public typealias ViewModel = MyBonusesViewModel

	// MARK: - Outlets
	@IBOutlet weak private var totalAmountValueLabel: UILabel!
	@IBOutlet weak private var totalAmountKeyLabel: UILabel!
	@IBOutlet weak private var blockedAmountValueLabel: UILabel!
	@IBOutlet weak private var blockedAmountKeyLabel: UILabel!
	@IBOutlet weak private var containerView: UIView!

	// MARK: - Properties
    @Inject(from: .viewModels) public var viewModel: ViewModel
    public lazy var navigator = MyBonusesNavigator(viewController: self)
    private let disposeBag = DisposeBag()
	public lazy var collectionViewController = ABCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
		setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

	// MARK: - Setup methods
	private func setup() {
		setBaseBackgroundColor(to: .secondaryBg())
		setupNavigationItems()
		setupCollectionViewController()
		setupFooter()
	}

	private func setupCollectionViewController() {
		setupCollectionViewRegistrations()
		containerView.addSubview(collectionViewController.view)
		collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
		collectionViewController.view.pin(to: containerView)
		collectionViewController.collectionView.alwaysBounceVertical = true
		collectionViewController.viewModel = viewModel
		setupCollectionViewFlowLayout()
	}

	private func setupCollectionViewRegistrations() {
		collectionViewController.collectionView?.register(types: [
			ActiveMyBonusesHeaderCollectionViewCell.self,
			ActiveMyBonusItemCollectionViewCell.self,
			EndedMyBonusesHeaderCollectionViewCell.self,
			EndedMyBonusItemCollectionViewCell.self
		])
	}

	private func setupCollectionViewFlowLayout() {
		collectionViewController.flowLayout?.minimumInteritemSpacing = 8
		collectionViewController.flowLayout?.minimumLineSpacing = 8
		collectionViewController.flowLayout?.sectionInset = .init(top: 5, left: 15, bottom: 1, right: 15)
	}

	private func setupFooter() {
		setupFooterLabels()
	}

	private func setupFooterLabels() {
		setupTotalAmountKeyLabel()
		setupTotalAmountValueLabel()
		setupBlockedAmountKeyLabel()
		setupBlockedAmountValueLabel()
	}

	private func setupTotalAmountKeyLabel() {
		totalAmountKeyLabel.text = R.string.localization.your_bonus.localized()
	}

	private func setupTotalAmountValueLabel() {
	}

	private func setupBlockedAmountKeyLabel() {
		blockedAmountKeyLabel.text = R.string.localization.blocked_amount.localized()
	}

	private func setupBlockedAmountValueLabel() {
	}

	private func setupNavigationItems() {
		setBackBarButtonItemIfNeeded()
		setupRightBarButtonItem()
	}

	private func setupRightBarButtonItem() {
		let balanceTipsButton = makeBarButtonWith(title: R.string.localization.my_bonuses_balance_tips.localized(),
												  color: DesignSystem.Color.secondaryText(alpha: 0.6))
		navigationItem.rightBarButtonItem = balanceTipsButton.barButtonItem
		balanceTipsButton.button.addTarget(self, action: #selector(balanceTipsClickHandler), for: .touchUpInside)
	}

	@objc
	private func balanceTipsClickHandler() {
		// TODO
	}

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: ViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: MyBonusesViewModelOutputAction) {
		switch action {
		case .initialize(let appListDataProvider):
			collectionViewController.dataProvider = appListDataProvider
		case .configureEmptyState(let emptyStateViewModel):
			collectionViewController.configureEmptyState(with: emptyStateViewModel)
		case .reloadIndexPathes(let indexPathes):
			UIView.performWithoutAnimation {
				collectionViewController.collectionView.reloadItems(at: indexPathes)
			}
		case .reloadItems(let items, let insertionIndexPathes, let deletionIndexPathes):
			collectionViewController.reloadItems(items: items, insertionIndexPathes: insertionIndexPathes, deletionIndexPathes: deletionIndexPathes)
		case .setLoading(let loadingType):
			break	// TODO
		}
    }

    private func didRecive(route: MyBonusesViewModelRoute) {
		switch route {
		case .open(let game): break // TODO
		}
    }
}

extension MyBonusesViewController: CommonBarButtonProviding { }