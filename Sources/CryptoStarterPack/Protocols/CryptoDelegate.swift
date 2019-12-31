import Foundation
import Bedrock

public protocol CryptoDelegate {
    static func hash(_ input: [Bool]) -> [Bool]?
    static func hash<T: DataEncodable>(_ input: T) -> Data?
}
