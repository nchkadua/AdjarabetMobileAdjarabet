//
//  BaseViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BaseViewModel: AnyObject, LanguageChangeObserving, LanguageChangeNotifing {
}

public class DefaultBaseViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    @Inject public var languageStorage: LanguageStorage

    public func observeLanguageChange() {
        languageStorage.currentLanguageObservable.subscribe(onNext: { [weak self] _ in
            self?.languageDidChange()
        }).disposed(by: disposeBag)
    }

    public func languageDidChange() {
    }
}

public protocol LanguageChangeNotifing {
    func languageDidChange()
}

public protocol LanguageChangeObserving {
    func observeLanguageChange()
}
