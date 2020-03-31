public protocol AdjarabetCoreCodableType {
    associatedtype T where T: Codable
    associatedtype H where H: HeaderProtocol
    
    var codable: T { get }
    var header: H? { get }
    init(codable: T, header: H?)
}

public protocol HeaderProtocol {
    init(headers: [AnyHashable : Any]?) throws
}
