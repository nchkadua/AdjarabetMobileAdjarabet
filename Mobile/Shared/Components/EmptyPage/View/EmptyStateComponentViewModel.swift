//
//  EmptyPageComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol EmptyStateComponentViewModel: EmptyStateComponentViewModelInput,
                                                EmptyStateComponentViewModelOutput {}

public struct EmptyStateComponentViewModelParams {
    public let icon: UIImage
    public let title: String
    public let description: String
    public let position: EmptyStatePosition

    init(
        icon: UIImage = R.image.promotions.casino_icon()!,
        title: String = "",
        description: String = "",
        position: EmptyStatePosition = .centered
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.position = position
    }
}

public protocol EmptyStateComponentViewModelInput {
    func didBind()
    func set(title: String)
}

public protocol EmptyStateComponentViewModelOutput {
    var action: Observable<EmptyStateComponentViewModelOutputAction> { get }
    var params: EmptyStateComponentViewModelParams { get }
}

public enum EmptyStateComponentViewModelOutputAction {
    case titleUpdate(title: String)
}

public class DefaultEmptyStateComponentViewModel {
    public var params: EmptyStateComponentViewModelParams
    private let actionSubject = PublishSubject<EmptyStateComponentViewModelOutputAction>()
    public init(params: EmptyStateComponentViewModelParams) {
        self.params = params
    }
}

public enum EmptyStatePosition {
    case centered
    case centeredWithBottomSpace(space: CGFloat)
}

extension DefaultEmptyStateComponentViewModel: EmptyStateComponentViewModel {
    public func set(title: String) {
        actionSubject.onNext(.titleUpdate(title: title))
    }

    public var action: Observable<EmptyStateComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
