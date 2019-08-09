import Foundation

public protocol AsymmetricDelegate {
    associatedtype PublicKey: Stringable
    associatedtype PrivateKey: Stringable
    associatedtype Signature: Stringable
    
    static func sign<T: BinaryEncodable>(message: T, privateKey: PrivateKey) -> Signature?
    static func verify<T: BinaryEncodable>(message: T, publicKey: PublicKey, signature: Signature) -> Bool
    
    static func encrypt(data: Data, publicKey: PublicKey) -> Data?
    static func decrypt(data: Data, privateKey: PrivateKey) -> Data?
}
