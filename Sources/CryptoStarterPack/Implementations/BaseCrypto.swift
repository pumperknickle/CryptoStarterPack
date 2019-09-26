import Crypto
import Bedrock
import Foundation

public struct BaseCrypto: CryptoDelegate {
    public static func hash(_ input: [Bool]) -> [Bool]? {
        return try? SHA256.hash(input.literal()).toBoolArray()
    }
}
