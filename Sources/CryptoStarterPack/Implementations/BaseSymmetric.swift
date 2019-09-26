import Foundation
import Bedrock
import Crypto

public struct BaseSymmetric: SymmetricDelegate {
    public typealias Key = UInt256
    
    public static func encrypt(plainText: [Bool], key: Key) -> [Bool]? {
        guard let plaintextData = plainText.literal().data(using: .utf8) else { return nil }
        return try? AES256CBC.encrypt(plaintextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: UInt64.min.bytes + UInt64.min.bytes).toBoolArray()
    }
    
    public static func decrypt(cipherText: [Bool], key: Key) -> [Bool]? {
        guard let ciphertextData = Data(raw: cipherText) else { return nil }
        guard let plaintextData = try? AES256CBC.decrypt(ciphertextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: UInt64.min.bytes + UInt64.min.bytes) else { return nil }
        guard let plaintextString = String(bytes: plaintextData, encoding: .utf8) else { return nil }
        return plaintextString.bools()
    }
}
