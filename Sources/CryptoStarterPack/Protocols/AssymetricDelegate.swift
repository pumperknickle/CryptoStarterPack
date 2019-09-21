import Foundation

public protocol AsymmetricDelegate {
    associatedtype PublicKey: Stringable
    associatedtype PrivateKey: Stringable
    associatedtype Signature: Stringable
    
    static func sign(message: [Bool], privateKey: PrivateKey) -> Signature?
    static func verify(message: [Bool], publicKey: PublicKey, signature: Signature) -> Bool
    
    static func encrypt(plainText: [Bool], publicKey: PublicKey) -> [Bool]?
    static func decrypt(cipherText: [Bool], privateKey: PrivateKey) -> [Bool]?
}
