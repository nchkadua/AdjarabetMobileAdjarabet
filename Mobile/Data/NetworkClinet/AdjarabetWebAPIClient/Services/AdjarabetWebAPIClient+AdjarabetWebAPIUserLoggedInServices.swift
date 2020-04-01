extension AdjarabetWebAPIClient: AdjarabetWebAPIUserLoggedInServices {
    public func userLoggedIn<T: Codable>(userId: Int, domain: String, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) {
        let request = standartRequestBuilder
            .set(method: .userLoggedIn)
            .set(userId: userId, domain: domain)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        performTask(request: request, type: T.self, completion: completion)
    }
}
