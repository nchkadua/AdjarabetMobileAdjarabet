import Foundation

public class AdjarabetWebAPIClient: AdjarabetWebAPIServices {
    public let baseUrl: URL
    
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    public var baseUrlComponents: URLComponents {
        URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
    }
    
    public enum Method: String {
        case userLoggedIn
    }
    
    public func performTask<T: Codable>(request: URLRequest, type: T.Type, completion: ((_ response: Result<T, Error>) -> Void)?) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async { completion?(.failure(error)) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion?(.failure(AdjarabetWebAPIClientError.dataIsEmpty(context: request.url!)))
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(json)
                let decoded = try jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion?(.success(decoded))
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.dataCorrupted(context)))
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.keyNotFound(key, context)))
                }
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.valueNotFound(value, context)))
                }
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                DispatchQueue.main.async {
                    completion?(.failure(DecodingError.typeMismatch(type, context)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
 
        task.resume()
    }
}
