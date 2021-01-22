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
    private static var myCardsTable = MyCardsTable()
    private var dataProvider: AppCellDataProviders = []
}

extension DefaultMyCardsViewModel: MyCardsViewModel {
    
    public var action: Observable<MyCardsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MyCardsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        setupMyCardsTable()
    }

    private func setupMyCardsTable() {
        DefaultMyCardsViewModel.myCardsTable.dataSource.forEach {
            var componentViewModel: AppCellDataProvider?
            if let myCard = $0 as? MyCard {
                let bankIcon = iconForBank(myCard.bank)
                let issuerIcon = iconForIssuer(myCard.issuer)
                let bankAlias = aliasForBank(myCard.bank)
                componentViewModel = DefaultMyCardComponentViewModel(params: .init(bankIcon: bankIcon,
                                                                                          bankAlias: bankAlias,
                                                                                          dateAdded: myCard.dateAdded,
                                                                                          cardNumber: myCard.number,
                                                                                          issuerIcon: issuerIcon))
                subscribe(to: componentViewModel as! MyCardComponentViewModel)
            } else if $0 is AddCard {
                componentViewModel = DefaultAddMyCardComponentViewModel()
            } else if $0 is VideoCard {
                componentViewModel = DefaultVideoCardComponentViewModel(params: .init())
            }
            if let componentViewModel = componentViewModel {
                dataProvider.append(componentViewModel)
            }
        }
        actionSubject.onNext(.initialize(dataProvider.makeList()))
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
        DefaultMyCardsViewModel.myCardsTable.dataSource.remove(at: index)
    }

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

    public func addCardsClicked() {
        
    }
}
