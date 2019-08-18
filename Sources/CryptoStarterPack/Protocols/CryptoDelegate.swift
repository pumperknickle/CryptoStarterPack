import Foundation

public protocol CryptoDelegate {
    static func hash(_ input: [Bool]) -> [Bool]?
}

public extension CryptoDelegate {
    static func hash(_ input: Data) -> [Bool]? {
        return Self.hash(input.toBoolArray())
    }
}
