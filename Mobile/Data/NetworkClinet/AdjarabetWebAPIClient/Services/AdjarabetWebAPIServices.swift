public protocol AdjarabetWebAPIServices: AdjarabetWebAPIUserLoggedInServices { }

public protocol AdjarabetWebAPIUserLoggedInServices {
    func userLoggedIn<T: Codable>(userId: Int, domain: String, sessionId: String, completion: @escaping (Result<T, Error>) -> Void)
}
