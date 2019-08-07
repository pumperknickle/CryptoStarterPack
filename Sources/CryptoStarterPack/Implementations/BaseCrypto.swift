import Crypto
import Foundation

public struct BaseCrypto: CryptoDelegate {
    public static func hash(_ data: Data) -> [Bool]? {
        guard let digest = try? SHA256.hash(data) else { return nil }
        return digest.toBoolArray()
    }
}
