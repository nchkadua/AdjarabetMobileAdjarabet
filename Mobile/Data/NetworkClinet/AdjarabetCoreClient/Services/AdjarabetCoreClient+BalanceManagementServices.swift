extension AdjarabetCoreClient: BalanceManagementServices {
    public func balance<T: AdjarabetCoreCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) {
        let request = standartRequestBuilder
            .set(method: .balance)
            .set(userId: userId, currencyId: currencyId, isSingle: isSingle)
            .setHeader(key: .cookie, value: sessionId)
            .build()
        
        performTask(request: request, type: T.self, completion: completion)
    }
}
