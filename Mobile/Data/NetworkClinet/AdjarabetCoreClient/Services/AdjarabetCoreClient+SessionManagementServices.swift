extension AdjarabetCoreClient: SessionManagementServices {
    public func aliveSession<T: AdjarabetCoreCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) {
        let request = standartRequestBuilder
            .set(method: .aliveSession)
            .set(userId: userId)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        performTask(request: request, type: T.self, completion: completion)
    }
}
