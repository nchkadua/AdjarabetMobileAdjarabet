public class AdjarabetEndpoints {
    public static var coreAPIUrl: URL {
        Bundle.main.coreAPIUrl
    }

    public static var webAPIUrl: URL {
        URL(string: "https://webapi.adjarabet.com")!
    }
}
