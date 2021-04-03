//
//  NotificationsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol NotificationsRepository {
    typealias NotificationsHandler = (Result<NotificationItemsEntity, Error>) -> Void
    func notifications(params: NotificationParams,
                       handler: @escaping NotificationsHandler)
}

struct NotificationParams {
    let page: Int
    let domain: String
}

public class DefaultNotificationsRepository: NotificationsRepository {
    @Inject private var dataTransferService: DataTransferService
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    func notifications(params: NotificationParams, handler: @escaping NotificationsHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/users/getnotification?user_id=\(userId)&page=\(params.page)&language=\(languageStorage.currentLanguage.localizableIdentifier)&domain=\(params.domain)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: NotificationDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
