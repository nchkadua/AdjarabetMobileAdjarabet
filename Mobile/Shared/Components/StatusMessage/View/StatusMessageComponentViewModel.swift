//
//  StatusMessageComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol StatusMessageComponentViewModel: StatusMessageComponentViewModelInput,
                                                StatusMessageComponentViewModelOutput {}

public struct StatusMessageComponentViewModelParams {
}

public protocol StatusMessageComponentViewModelInput {
    var type: StatusMessageComponentType { get set }
    func didBind()
}

public protocol StatusMessageComponentViewModelOutput {
    var action: Observable<StatusMessageComponentViewModelOutputAction> { get }
    var params: StatusMessageComponentViewModelParams { get }
}

public enum StatusMessageComponentViewModelOutputAction {
    case configure(with: StatusMessageComponentViewModel)
}

public enum StatusMessageComponentType {
    case initial
    case connectionEstablished
    case connectionFailed
    
    var color: UIColor {
        switch self {
        case .initial: return .clear
		case .connectionEstablished: return StatusMessageComponentConstants.Colors.green
		case .connectionFailed: return StatusMessageComponentConstants.Colors.red
        }
    }
    
    var description: String {
        switch self {
        case .initial: return ""
		case .connectionEstablished: return R.string.localization.status_message_interter_connection_established.localized()
		case .connectionFailed: return R.string.localization.status_message_interter_connection_lost.localized()
        }
    }
}

public class DefaultStatusMessageComponentViewModel: DefaultBaseViewModel {
    public var params: StatusMessageComponentViewModelParams
    private let actionSubject = PublishSubject<StatusMessageComponentViewModelOutputAction>()
    public var type: StatusMessageComponentType = NetworkConnectionManager.shared.reachability.isReachable ? .initial : .connectionFailed {
        didSet {
            actionSubject.onNext(.configure(with: self))
        }
    }
    public init(params: StatusMessageComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultStatusMessageComponentViewModel: StatusMessageComponentViewModel {
    public var action: Observable<StatusMessageComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
