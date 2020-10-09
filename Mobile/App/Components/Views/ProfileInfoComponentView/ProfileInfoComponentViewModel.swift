//
//  ProfileInfoComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/5/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ProfileInfoComponentViewModel: ProfileInfoComponentViewModelInput, ProfileInfoComponentViewModelOutput {
}

public struct ProfileInfoComponentViewModelParams {
    public var username: String
    public var userId: Int
}

public protocol ProfileInfoComponentViewModelInput {
    func didBind()
    func didCopyUserId()
}

public protocol ProfileInfoComponentViewModelOutput {
    var action: Observable<ProfileInfoComponentViewModelOutputAction> { get }
    var params: ProfileInfoComponentViewModelParams { get }
}

public enum ProfileInfoComponentViewModelOutputAction {
    case set(username: String, userId: Int)
    case didCopyUserId(userId: String)
}

public class DefaultProfileInfoComponentViewModel {
    public var params: ProfileInfoComponentViewModelParams
    private let actionSubject = PublishSubject<ProfileInfoComponentViewModelOutputAction>()

    public init (params: ProfileInfoComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultProfileInfoComponentViewModel: ProfileInfoComponentViewModel {
    public var action: Observable<ProfileInfoComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        let username = params.username
        let userId = params.userId

        actionSubject.onNext(.set(username: username, userId: userId))
    }

    public func didCopyUserId() {
        actionSubject.onNext(.didCopyUserId(userId: String(params.userId)))
    }
}
