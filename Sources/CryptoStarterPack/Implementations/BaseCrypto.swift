import Crypto
import Foundation

public struct BaseCrypto: CryptoDelegate {
    public static func hash(_ input: [Bool]) -> [Bool]? {
        guard let digest = try? SHA256.hash(input.literal()) else { return nil }
        return digest.toBoolArray()
    }
}
