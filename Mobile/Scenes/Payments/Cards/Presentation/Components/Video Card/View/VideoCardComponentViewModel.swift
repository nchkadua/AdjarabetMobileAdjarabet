//
//  VideoCardComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public enum AssetPathType {
    case bundle(name: String, extenstion: String = "mp4")
    case url(url: String)
}

public protocol VideoCardComponentViewModel: VideoCardComponentViewModelInput,
                                                VideoCardComponentViewModelOutput {}

public struct VideoCardComponentViewModelParams {
    let pathType: AssetPathType
}

public protocol VideoCardComponentViewModelInput {
    func didBind()
}

public protocol VideoCardComponentViewModelOutput {
    var action: Observable<VideoCardComponentViewModelOutputAction> { get }
    var params: VideoCardComponentViewModelParams { get }
}

public enum VideoCardComponentViewModelOutputAction {
    case setAssetWith(pathType: AssetPathType)
}

public class DefaultVideoCardComponentViewModel {
    public var params: VideoCardComponentViewModelParams
    private let actionSubject = PublishSubject<VideoCardComponentViewModelOutputAction>()
    public init(params: VideoCardComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultVideoCardComponentViewModel: VideoCardComponentViewModel {
    public var action: Observable<VideoCardComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setAssetWith(pathType: params.pathType))
    }
}
