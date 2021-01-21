//
//  VideoCardComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol VideoCardComponentViewModel: VideoCardComponentViewModelInput,
                                                VideoCardComponentViewModelOutput {}

public struct VideoCardComponentViewModelParams {
    
}

public protocol VideoCardComponentViewModelInput {
    func didBind()
}

public protocol VideoCardComponentViewModelOutput {
    var action: Observable<VideoCardComponentViewModelOutputAction> { get }
    var params: VideoCardComponentViewModelParams { get }
}

public enum VideoCardComponentViewModelOutputAction {
    
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
    }
}
