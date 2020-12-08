//
//  AccessHistoryComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccessHistoryComponentViewModel: AccessHistoryComponentViewModelInput,
                                                 AccessHistoryComponentViewModelOutput {}

public struct AccessHistoryComponentViewModelParams {
    public let ip: String
    public let device: String
    public let date: String
    public let deviceIcon: UIImage
}

public protocol AccessHistoryComponentViewModelInput {
    func didBind()
}

public protocol AccessHistoryComponentViewModelOutput {
    var action: Observable<AccessHistoryComponentViewModelOutputAction> { get }
    var params: AccessHistoryComponentViewModelParams { get }
}

public enum AccessHistoryComponentViewModelOutputAction {
    case set(ip: String, device: String, date: String, deviceIcon: UIImage)
}

public class DefaultAccessHistoryComponentViewModel {
    public var params: AccessHistoryComponentViewModelParams
    private let actionSubject = PublishSubject<AccessHistoryComponentViewModelOutputAction>()
    public init(params: AccessHistoryComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultAccessHistoryComponentViewModel: AccessHistoryComponentViewModel {
    public var action: Observable<AccessHistoryComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(ip: params.ip, device: params.device, date: params.date, deviceIcon: params.deviceIcon))
    }
}
