//
//  BaseViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol BaseViewModel: AnyObject,
                        LanguageChangeObserving,
                        LanguageChangeNotifing,
                        ErrorThrowing {}

public class DefaultBaseViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    @Inject public var languageStorage: LanguageStorage
    private let errorSubject = PublishSubject<ABError>()

    var errorObservable: Observable<ABError> {
        errorSubject.asObserver()
    }

    func observeLanguageChange() {
        languageStorage.currentLanguageObservable.subscribe(onNext: { [weak self] _ in
            self?.languageDidChange()
        }).disposed(by: disposeBag)
    }

    func languageDidChange() {
    }

    func show(error: ABError) {
        errorSubject.onNext(error)
    }

    func handler<Data>(onSuccessHandler: @escaping (Data) -> Void) -> (Result<Data, ABError>) -> Void {
        return { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                onSuccessHandler(data)
            case .failure(let error):
                self.show(error: error)
            }
        }
    }
}

protocol LanguageChangeNotifing {
    func languageDidChange()
}

protocol LanguageChangeObserving {
    func observeLanguageChange()
}

protocol ErrorThrowing {
    var errorObservable: Observable<ABError> { get }
}
