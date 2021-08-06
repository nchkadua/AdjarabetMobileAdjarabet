//
//  AddressChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AddressChangeViewModel: AddressChangeViewModelInput, AddressChangeViewModelOutput {
}

public struct AddressChangeViewModelParams {
    public let paramsOutputAction = PublishSubject<Action>()
    public enum Action {
        case success(newAddress: String)
    }
}

public protocol AddressChangeViewModelInput: AnyObject {
    var params: AddressChangeViewModelParams { get set }
    func viewDidLoad()
    func approved(address: String)
}

public protocol AddressChangeViewModelOutput {
    var action: Observable<AddressChangeViewModelOutputAction> { get }
    var route: Observable<AddressChangeViewModelRoute> { get }
}

public enum AddressChangeViewModelOutputAction {
    case dismiss
    case showError(error: String)
}

public enum AddressChangeViewModelRoute {
}

public class DefaultAddressChangeViewModel {
    public var params: AddressChangeViewModelParams
    private let actionSubject = PublishSubject<AddressChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<AddressChangeViewModelRoute>()
    @Inject(from: .repositories) private var repo: AddressWritableRepository

    public init(params: AddressChangeViewModelParams) {
        self.params = params
    }
}

extension DefaultAddressChangeViewModel: AddressChangeViewModel {
    public var action: Observable<AddressChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AddressChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        /*
        repo.changeAddress(
            with: .init (
                addressLine1: "221B Baker Street",
                addressLine2: "Flat #23",
                addressLine3: "Marylebone",
                town: "London",
                county: "Greater London",
                region: "Greater London",
                postCode: "NW1 6XE"
            )
        ) { result in
            switch result {
            case .success:
                print("changeAddress.Success")
            case .failure(let error):
                print("changeAddress.Failure:", error)
            }
        }
        */
    }

    public func approved(address: String) {
        repo.changeAddress(
            with: .init(
                address: address
            )
        ) { [weak self] result in
            switch result {
            case .success:
                self?.params.paramsOutputAction.onNext(.success(newAddress: address))
                self?.actionSubject.onNext(.dismiss)
            case .failure(let error):
                {}() // TODO
                // self?.actionSubject.onNext(.showError(error: error.description.description))
            }
        }
    }
}
