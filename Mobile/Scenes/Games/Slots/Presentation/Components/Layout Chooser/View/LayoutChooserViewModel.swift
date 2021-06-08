//
//  LayoutChooserViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 5/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol LayoutChooserViewModel: LayoutChooserViewModelInput, LayoutChooserViewModelOutput { }

protocol LayoutChooserViewModelInput {
    // for view to call
    func listLayoutTapped()
    func gridLayoutTapped()
}

protocol LayoutChooserViewModelOutput {
    var action: Observable<LayoutChooserViewModelAction> { get }
}

enum LayoutChooserViewModelAction {
    // for other listeners
    case listLayoutTapped
    case gridLayoutTapped
}

// MARK: - Default Implementation

class DefaultLayoutChooserViewModel: LayoutChooserViewModel {
    static var `default`: LayoutChooserViewModel { DefaultLayoutChooserViewModel() }

    private let actionSubject = PublishSubject<LayoutChooserViewModelAction>()
    var action: Observable<LayoutChooserViewModelAction> { actionSubject.asObserver() }

    func listLayoutTapped() {
        actionSubject.onNext(.listLayoutTapped)
    }

    func gridLayoutTapped() {
        actionSubject.onNext(.gridLayoutTapped)
    }
}
