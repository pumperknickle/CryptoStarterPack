import Foundation
import Crypto

public struct BaseSymmetric: SymmetricDelegate {
    public typealias Key = UInt256
    
    public static func encrypt<T: BinaryEncodable>(plaintext: T, key: Key) -> [Bool]? {
        guard let plaintextData = plaintext.toBoolArray().literal().data(using: .utf8) else { return nil }
        return try? AES256CBC.encrypt(plaintextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: UInt64.min.bytes + UInt64.min.bytes).toBoolArray()
    }
    
    public static func decrypt<T: BinaryEncodable>(ciphertext: [Bool], key: Key) -> T? {
        guard let ciphertextData = Data(raw: ciphertext) else { return nil }
        guard let plaintextData = try? AES256CBC.decrypt(ciphertextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: UInt64.min.bytes + UInt64.min.bytes) else { return nil }
        guard let plaintextString = String(bytes: plaintextData, encoding: .utf8) else { return nil }
        return T(raw: plaintextString.bools())
    }
}
