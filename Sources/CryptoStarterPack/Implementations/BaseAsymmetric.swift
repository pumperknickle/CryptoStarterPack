import Foundation
import Bedrock
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
    
    public static func encrypt(plainText: Data, publicKey: String) -> Data? {
        guard let ciphertext = try? RSA.encrypt(plainText, key: .public(pem: publicKey)) else { return nil }
        return ciphertext
    }
    
    public static func decrypt(cipherText: Data, privateKey: String) -> Data? {
        guard let plaintext = try? RSA.decrypt(cipherText, key: .private(pem: privateKey)) else { return nil }
		return plaintext
    }
}
