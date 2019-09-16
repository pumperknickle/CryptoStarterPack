import Foundation

public protocol CryptoDelegate {
    static func hash<T: BinaryEncodable>(_ input: T) -> [Bool]?
}
