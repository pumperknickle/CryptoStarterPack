import Crypto
import Foundation

public struct BaseCrypto: CryptoDelegate {
    public static func hash<T: BinaryEncodable>(_ input: T) -> [Bool]? {
        return try? SHA256.hash(input.toBoolArray().literal()).toBoolArray()
    }
}
