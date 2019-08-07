import Foundation

public protocol CryptoDelegate {
    static func hash(_ data: Data) -> [Bool]?
}
