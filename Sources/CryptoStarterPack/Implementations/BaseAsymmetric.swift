import Foundation
import Bedrock
import Crypto

public struct BaseAsymmetric: AsymmetricDelegate {
    public static func sign(message: [Bool], privateKey: [Bool]) -> [Bool]? {
        guard let pkString = String(raw: privateKey) else { return nil }
        return try? RSA.SHA256.sign(message.literal(), key: .private(pem: pkString)).toBoolArray()
    }
    
    public static func verify(message: [Bool], publicKey: [Bool], signature: [Bool]) -> Bool {
        guard let signatureData = Data(raw: signature) else { return false }
        guard let pkString = String(raw: publicKey) else { return false }
        guard let result = try? RSA.SHA256.verify(signatureData, signs: message.literal(), key: .public(pem: pkString)) else { return false }
        return result
    }
    
    public static func encrypt<T: DataEncodable>(plainText: T, publicKey: [Bool]) -> [Bool]? {
        guard let pkString = String(raw: publicKey) else { return nil }
        guard let ciphertext = try? RSA.encrypt(plainText.toData(), key: .public(pem: pkString)) else { return nil }
        return ciphertext.toBoolArray()
    }
    
    public static func decrypt<T: DataEncodable>(cipherText: [Bool], privateKey: [Bool]) -> T? {
        guard let pkString = String(raw: privateKey) else { return nil }
        guard let ctData = Data(raw: cipherText) else { return nil }
        guard let plaintext = try? RSA.decrypt(ctData, key: .private(pem: pkString)) else { return nil }
        return T(data: plaintext)
    }
}
