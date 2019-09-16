import Foundation
import Crypto

public struct BaseAsymmetric: AsymmetricDelegate {
    public typealias PublicKey = String
    public typealias PrivateKey = String
    public typealias Signature = Data
    
    public static func sign<T: BinaryEncodable>(message: T, privateKey: String) -> Data? {
        guard let signature = try? RSA.SHA256.sign(message.toBoolArray().literal(), key: .private(pem: privateKey)) else { return nil }
        return signature
    }
    
    public static func verify<T: BinaryEncodable>(message: T, publicKey: String, signature: Data) -> Bool {
        guard let result = try? RSA.SHA256.verify(signature, signs: message.toBoolArray().literal(), key: .public(pem: publicKey)) else { return false }
        return result
    }
    
    public static func encrypt<T: BinaryEncodable>(message: T, publicKey: String) -> [Bool]? {
        guard let data = message.toBoolArray().literal().data(using: .utf8) else { return nil }
        guard let ciphertext = encrypt(data: data, publicKey: publicKey) else { return nil }
        return ciphertext.toBoolArray()
    }
    
    public static func decrypt<T: BinaryEncodable>(ciphertext: [Bool], privateKey: String) -> T? {
        guard let data = Data(raw: ciphertext) else { return nil }
        guard let plaintext = decrypt(data: data, privateKey: privateKey) else { return nil }
        guard let stringLit = String(bytes: plaintext, encoding: .utf8) else { return nil }
        return T(raw: stringLit.bools())
    }
    
    public static func encrypt(data: Data, publicKey: String) -> Data? {
        return try? RSA.encrypt(data, key: .public(pem: publicKey))
    }
    
    public static func decrypt(data: Data, privateKey: String) -> Data? {
        return try? RSA.decrypt(data, key: .private(pem: privateKey))
    }
}
