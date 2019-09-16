import Foundation

public protocol CryptoDelegate {
    static func hash(_ input: [Bool]) -> [Bool]?
}
