import Foundation

public protocol AsymmetricDelegate {
    associatedtype PublicKey: Stringable
    associatedtype PrivateKey: Stringable
    associatedtype Signature: Stringable
    
    static func sign<T: BinaryEncodable>(message: T, privateKey: PrivateKey) -> Signature?
    static func verify<T: BinaryEncodable>(message: T, publicKey: PublicKey, signature: Signature) -> Bool
    
    static func encrypt<T: BinaryEncodable>(message: T, publicKey: PublicKey) -> [Bool]?
    static func decrypt<T: BinaryEncodable>(ciphertext: [Bool], privateKey: PrivateKey) -> T?
}
