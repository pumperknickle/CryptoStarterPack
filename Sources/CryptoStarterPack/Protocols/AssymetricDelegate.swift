import Foundation
import Bedrock

public protocol AsymmetricDelegate {
    associatedtype PublicKey: Stringable
    associatedtype PrivateKey: Stringable
    associatedtype Signature: Stringable
    
    static func sign(message: [Bool], privateKey: PrivateKey) -> Signature?
    static func verify(message: [Bool], publicKey: PublicKey, signature: Signature) -> Bool
    
    static func encrypt(plainText: Data, publicKey: PublicKey) -> Data?
    static func decrypt(cipherText: Data, privateKey: PrivateKey) -> Data?
}
