import Foundation
import Crypto

public struct BaseAsymmetric: AsymmetricDelegate {
    public typealias PublicKey = String
    public typealias PrivateKey = String
    public typealias Signature = Data
    
    public static func sign(message: [Bool], privateKey: String) -> Data? {
        return try? RSA.SHA256.sign(message.literal(), key: .private(pem: privateKey))
    }
    
    public static func verify(message: [Bool], publicKey: String, signature: Data) -> Bool {
        guard let result = try? RSA.SHA256.verify(signature, signs: message.literal(), key: .public(pem: publicKey)) else { return false }
        return result
    }
    
    public static func encrypt(plainText: [Bool], publicKey: String) -> [Bool]? {
        guard let data = plainText.literal().data(using: .utf8) else { return nil }
        guard let ciphertext = try? RSA.encrypt(data, key: .public(pem: publicKey)) else { return nil }
        return ciphertext.toBoolArray()
    }
    
    public static func decrypt(cipherText: [Bool], privateKey: String) -> [Bool]? {
        guard let data = Data(raw: cipherText) else { return nil }
        guard let plaintext = try? RSA.decrypt(data, key: .private(pem: privateKey)) else { return nil }
        guard let stringLit = String(bytes: plaintext, encoding: .utf8) else { return nil }
        return stringLit.bools()
    }
}
