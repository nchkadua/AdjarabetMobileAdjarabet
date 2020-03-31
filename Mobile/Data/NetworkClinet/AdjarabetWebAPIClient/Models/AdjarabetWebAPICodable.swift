public class AdjarabetWebAPICodable {
    public struct UserLoggedIn: Codable {
        public let success, statusCode: Int
        public let data: DataClass
        
        public struct DataClass: Codable {
            public let amountSuggestions, widgetOrder: [String]

            enum CodingKeys: String, CodingKey {
                case amountSuggestions
                case widgetOrder = "WidgetOrder"
            }
        }
    }
}
