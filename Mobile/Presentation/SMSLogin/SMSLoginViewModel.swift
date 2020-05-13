//
//  SMSLoginViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SMSLoginViewModel: SMSLoginViewModelInput, SMSLoginViewModelOutput {
}

public struct SMSLoginViewModelParams {
}

public protocol SMSLoginViewModelInput {
    func viewDidLoad()
    func textDidChange(to text: String?)
    func shouldChangeCharacters(for text: String) -> Bool
}

public protocol SMSLoginViewModelOutput {
    var action: Observable<SMSLoginViewModelOutputAction> { get }
    var route: Observable<SMSLoginViewModelRoute> { get }
    var params: SMSLoginViewModelParams { get }
}

public enum SMSLoginViewModelOutputAction {
    case configureSMSInputForNumberOfItems(Int)
    case updateSMSCodeInputView(text: [String?])
}

public enum SMSLoginViewModelRoute {
}

public class DefaultSMSLoginViewModel {
    private let actionSubject = PublishSubject<SMSLoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<SMSLoginViewModelRoute>()
    public let params: SMSLoginViewModelParams
    private let smsCodeLength = 6

    public init(params: SMSLoginViewModelParams) {
        self.params = params
    }
}

extension DefaultSMSLoginViewModel: SMSLoginViewModel {
    public var action: Observable<SMSLoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SMSLoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.configureSMSInputForNumberOfItems(smsCodeLength))
    }

    public func textDidChange(to text: String?) {
        let text = text ?? ""

        let texts = (0..<smsCodeLength).map { index in
            index < text.count ? String(text[text.index(text.startIndex, offsetBy: index)]) : nil
        }

        actionSubject.onNext(.updateSMSCodeInputView(text: texts))
    }

    public func shouldChangeCharacters(for text: String) -> Bool {
        text.count <= smsCodeLength
    }
}
