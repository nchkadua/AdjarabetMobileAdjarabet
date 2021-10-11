//
//  BlockedUserNotificationComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 23.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BlockedUserNotificationComponentViewModel: BlockedUserNotificationComponentViewModelInput,
                                                BlockedUserNotificationComponentViewModelOutput {}

public struct BlockedUserNotificationComponentViewModelParams {
	var errorModel: ABError.Description.BlockedUserNotification

	init(errorModel: ABError.Description.BlockedUserNotification = .init()) {
		self.errorModel = errorModel
	}
}

public protocol BlockedUserNotificationComponentViewModelInput {
    func didBind()
}

public protocol BlockedUserNotificationComponentViewModelOutput {
    var action: Observable<BlockedUserNotificationComponentViewModelOutputAction> { get }
    var params: BlockedUserNotificationComponentViewModelParams { get }
}

public enum BlockedUserNotificationComponentViewModelOutputAction {
    case suspendTillSet(suspendTill: Date?)
}

public class DefaultBlockedUserNotificationComponentViewModel {
    public var params: BlockedUserNotificationComponentViewModelParams
    private let actionSubject = PublishSubject<BlockedUserNotificationComponentViewModelOutputAction>()

    public init(params: BlockedUserNotificationComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultBlockedUserNotificationComponentViewModel: BlockedUserNotificationComponentViewModel {
    public var action: Observable<BlockedUserNotificationComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
    }
}
