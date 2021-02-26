//
//  MyCardsViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MyCardsViewModel: MyCardsViewModelInput, MyCardsViewModelOutput {
}

public struct MyCardsViewModelParams {
}

public protocol MyCardsViewModelInput: AnyObject {
    func viewDidLoad()
    func addCardsClicked()
    func deleteCell(at index: Int)
}

public protocol MyCardsViewModelOutput {
    var action: Observable<MyCardsViewModelOutputAction> { get }
    var route: Observable<MyCardsViewModelRoute> { get }
}

public enum MyCardsViewModelOutputAction {
    case initialize(AppListDataProvider)
    case didDeleteCell(atIndexPath: IndexPath)
}

public enum MyCardsViewModelRoute {
}

public class DefaultMyCardsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<MyCardsViewModelOutputAction>()
    private let routeSubject = PublishSubject<MyCardsViewModelRoute>()
    @Inject(from: .useCases) private var paymentAccountUseCase: PaymentAccountUseCase
    private static var myCardsTable = MyCardsTable()
    private var dataProvider: AppCellDataProviders = []
}

extension DefaultMyCardsViewModel: MyCardsViewModel {
    public var action: Observable<MyCardsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MyCardsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        fetchMyCards { result in
            switch result {
            case .success:
                self.setupStaticCards()
                self.actionSubject.onNext(.initialize(self.dataProvider.makeList()))
            case .failure:
                self.setupStaticCards()
                self.actionSubject.onNext(.initialize(self.dataProvider.makeList()))
            }
        }
    }

    private func fetchMyCards(completion: @escaping (Result<Bool, Error>) -> Void) {
        paymentAccountUseCase.execute(params: .init()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paymentAccounts): // type - [PaymentAccountEntity]
                var componentViewModel: AppCellDataProvider?
                paymentAccounts.forEach { myCard in
                    if let id = myCard.id, let providerName = myCard.providerName, let dateCreated = myCard.dateCreated, let accountVisual = myCard.accountVisual {
                        componentViewModel = DefaultMyCardComponentViewModel(params: .init(id: id,
                                                                                           bankIcon: nil,
                                                                                           bankAlias: providerName,
                                                                                           dateAdded: dateCreated,
                                                                                           cardNumber: accountVisual,
                                                                                           issuerIcon: nil))
                        // swiftlint:disable force_cast
                        self.subscribe(to: componentViewModel as! MyCardComponentViewModel)
                    }

                    if let componentViewModel = componentViewModel {
                        self.dataProvider.append(componentViewModel)
                    }
                }
                completion(.success(true))
            case .failure(let error):
                self.setupStaticCards()
                print(error)
            }
        }
    }

    private func setupStaticCards() {
        var componentViewModel: AppCellDataProvider?
        DefaultMyCardsViewModel.myCardsTable.dataSource.forEach {
             if $0 is AddCard {
                componentViewModel = DefaultAddMyCardComponentViewModel()
            } else if $0 is VideoCard {
                componentViewModel = DefaultVideoCardComponentViewModel(params: .init())
            }
            if let componentViewModel = componentViewModel {
                self.dataProvider.append(componentViewModel)
            }
        }
    }

    private func subscribe(to myCardComponent: MyCardComponentViewModel) {
        myCardComponent.action.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .didDelete(let indexPath):
                self.actionSubject.onNext(.didDeleteCell(atIndexPath: indexPath))
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

    public func deleteCell(at index: Int) {
    }

    // MARK: Helper methods for future

    private func aliasForBank(_ bank: MyCard.Bank) -> String {
        var alias = ""
        switch bank {
        case .bog:
            alias = "საქართველოს ბანკი"
        case .tbc:
            alias = "თიბისი ბანკი"
        default:
            break
        }
        return alias
    }

    private func iconForBank(_ bank: MyCard.Bank) -> UIImage? {
        var icon: UIImage?
        switch bank {
        case .bog: icon = R.image.myCards.bog()
        case .tbc: icon = R.image.myCards.tbc()
        case .other: icon = nil
        }

        return icon
    }

    private func iconForIssuer(_ issuer: MyCard.Issuer) -> UIImage? {
        var icon: UIImage?
        switch issuer {
        case .masterCard: icon = R.image.myCards.mc()
        case .visa: icon = R.image.myCards.visa()
        case .other: icon = nil
        }
        return icon
    }

    // TODO: Irakli
    public func addCardsClicked() {
        // TODO: delete first
        // swiftlint:disable force_cast
        let id = (dataProvider[0] as! DefaultMyCardComponentViewModel).params.id
        paymentAccountUseCase.execute(params: .init(id: id)) { result in
            switch result {
            case .success:
                print("DeleteCard Success")
            case .failure(let error):
                print("DeleteCard Failure:", error)
            }
        }
    }
}
