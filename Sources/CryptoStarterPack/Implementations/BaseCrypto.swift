import Crypto
import Bedrock
import Foundation

public struct BaseCrypto: CryptoDelegate {
    public static func hash<T>(_ input: T) -> Data? where T : DataEncodable {
        return try? SHA256.hash(input.toData())
    }
    
    public static func hash(_ input: [Bool]) -> [Bool]? {
        return try? SHA256.hash(input.literal()).toBoolArray()
    }
}
