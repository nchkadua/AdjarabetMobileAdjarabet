
public class NetworkClientGETRequest: NetworkClientRequest, NetworkClientRequestable {
    public required init(method: Methodable, param: JSONParam, headerValues: HeaderValues) {
        super.init(httpMethod: .get, method: method, param: param, headerValues: headerValues)
    }
    
    public convenience required init(method: Methodable, param: JSONParam) {
        self.init(method: method, param: param, headerValues: [:])
    }
    
    public convenience required init(method: Methodable) {
        self.init(method: method, param: [:], headerValues: [:])
    }
}
