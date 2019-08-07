import Foundation
import Crypto

public struct BaseAsymmetric: AsymmetricDelegate {
    public typealias PublicKey = String
    public typealias PrivateKey = String
    public typealias Signature = Data
    
    public static func sign<T>(message: T, privateKey: String) -> Data? where T: BinaryEncodable {
        guard let signature = try? RSA.SHA256.sign(message.toBoolArray().literal(), key: .private(pem: privateKey)) else { return nil }
        return signature
    }
    
    public static func verify<T>(message: T, publicKey: String, signature: Data) -> Bool where T : BinaryEncodable {
        guard let result = try? RSA.SHA256.verify(signature, signs: message.toBoolArray().literal(), key: .public(pem: publicKey)) else { return false }
        return result
    }
    
    public static func encrypt(data: Data, publicKey: String) -> Data? {
        return try? RSA.encrypt(data, key: .public(pem: publicKey))
    }
    
    public static func decrypt(data: Data, privateKey: String) -> Data? {
        return try? RSA.decrypt(data, key: .private(pem: privateKey))
    }
}
