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

public protocol AddressChangeViewModelInput {
    func viewDidLoad()
}

public protocol AddressChangeViewModelOutput {
    var action: Observable<AddressChangeViewModelOutputAction> { get }
    var route: Observable<AddressChangeViewModelRoute> { get }
}

public enum AddressChangeViewModelOutputAction {
}

public enum AddressChangeViewModelRoute {
}

public class DefaultAddressChangeViewModel {
    private let actionSubject = PublishSubject<AddressChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<AddressChangeViewModelRoute>()
    @Inject(from: .repositories) private var repo: AddressWritableRepository
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
}
