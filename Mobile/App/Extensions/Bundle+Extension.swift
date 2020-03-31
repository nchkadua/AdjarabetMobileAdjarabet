public extension Bundle {
    var coreAPIUrl: URL {
        URL(string: infoDictionary?["CORE_API_URL"] as? String ?? "")!
    }
}
