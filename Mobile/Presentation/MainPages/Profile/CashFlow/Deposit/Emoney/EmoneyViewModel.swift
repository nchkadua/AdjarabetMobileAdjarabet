//
//  EmoneyViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol EmoneyViewModel: EmoneyViewModelInput, EmoneyViewModelOutput {
}

protocol EmoneyViewModelInput {
    func navigate()
}

protocol EmoneyViewModelOutput {
    var route: Observable<EmoneyViewModelRoute> { get }
}

enum EmoneyViewModelRoute {
    case navigate(WebViewModelParams)
}

struct DefaultEmoneyViewModel {
    private let routeSubject = PublishSubject<EmoneyViewModelRoute>()
}

extension DefaultEmoneyViewModel: EmoneyViewModel {
    var route: Observable<EmoneyViewModelRoute> { routeSubject.asObserver() }
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    func navigate() {
        let request = httpRequestBuilder
            .set(host: "https://www.emoney.ge/index.php/main/service?id=1157")
            .set(method: HttpMethodGet())
            .build()
        routeSubject.onNext(.navigate(.init(request: request)))
    }
}
