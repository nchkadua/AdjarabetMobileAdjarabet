//
//  MobileApiNotificationsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

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

    func read(params: NotificationStatusUpdateParams, handler: @escaping NotificationStatusUpdateHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/users/update_notification_status?user_id=\(userId)&notification_id=\(params.notifiationId)&status=read")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: NotificationStatusUpdateMessageDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }

    func delete(params: NotificationStatusUpdateParams, handler: @escaping NotificationStatusUpdateHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/users/update_notification_status?user_id=\(userId)&notification_id=\(params.notifiationId)&status=delete")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: NotificationStatusUpdateMessageDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
