//
//  PopupErrorViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 8/19/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol PopupErrorViewModel: PopupErrorViewModelInput, PopupErrorViewModelOutput {}

protocol PopupErrorViewModelInput {
    // view events to listen
    func didBind()
    func tapped(button index: Int)
    // events from outside to listen
    func set(error: ABError, description: ABError.Description.Popup)
}

protocol PopupErrorViewModelOutput {
    var action: Observable<PopupErrorViewModelOutputAction> { get }
}

enum PopupErrorViewModelOutputAction {
    // for view to listen
    case configure(from: ABError.Description.Popup)
    // for other listeners
    case tapped(button: ABError.Description.Popup.ButtonType, of: ABError)
}

class DefaultPopupErrorViewModel {
    private var error: ABError
    private var description: ABError.Description.Popup // description of *error*
    private let actionSubject = PublishSubject<PopupErrorViewModelOutputAction>()

    init(
        error: ABError = .init(),
        description: ABError.Description.Popup = .init()
    ) {
        self.error = error
        self.description = description
    }
}

extension DefaultPopupErrorViewModel: PopupErrorViewModel {
    var action: Observable<PopupErrorViewModelOutputAction> { actionSubject.asObserver() }

    func didBind() {
        actionSubject.onNext(.configure(from: description))
    }

    func tapped(button index: Int) {
        guard index >= 0, index < description.buttons.count else { return }
        let type = description.buttons[index]
        actionSubject.onNext(.tapped(button: type, of: error))
    }

    func set(error: ABError, description: ABError.Description.Popup) {
        self.error = error
        self.description = description
        actionSubject.onNext(.configure(from: description))
    }
}
