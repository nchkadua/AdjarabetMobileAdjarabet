extension AdjarabetCoreClient: AuthenticationService {
    public func login<T>(username: String, password: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void) where T : AdjarabetCoreCodableType {
        let request = standartRequestBuilder
            .set(method: .login)
            .set(username: username, password: password, channel: channel)
            .build()
        
        performTask(request: request, type: T.self, completion: completion)
    }
    
    public func smsCode<T>(username: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void) where T : AdjarabetCoreCodableType {
        let request = standartRequestBuilder
            .set(method: .smsCode)
            .set(username: username, channel: channel)
            .build()
        
        performTask(request: request, type: T.self, completion: completion)
    }
    
    public func logout<T>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) where T : AdjarabetCoreCodableType {
        let request = standartRequestBuilder
            .set(method: .logout)
            .set(userId: userId)
            .setHeader(key: .cookie, value: sessionId)
            .build()
        
        performTask(request: request, type: T.self, completion: completion)
    }
    
    public func login<T>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, Error>) -> Void) where T : AdjarabetCoreCodableType {
        let request = standartRequestBuilder
            .set(method: .loginOtp)
            .set(username: username, code: code, loginType: loginType)
            .build()
        
        performTask(request: request, type: T.self, completion: completion)
    }
}
