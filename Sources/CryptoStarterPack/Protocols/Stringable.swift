import Foundation

public protocol Stringable: Codable, Hashable, BinaryEncodable, Comparable {
    func toString() -> String
    init?(stringValue: String)
}
