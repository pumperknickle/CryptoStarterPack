import Foundation

public protocol AsymmetricDelegate {
    associatedtype PublicKey: BinaryEncodable
    associatedtype PrivateKey: BinaryEncodable
    associatedtype Signature: BinaryEncodable
    
    static func sign<T: BinaryEncodable>(message: T, privateKey: PrivateKey) -> Signature?
    static func verify<T: BinaryEncodable>(message: T, publicKey: PublicKey, signature: Signature) -> Bool
    
    static func encrypt(data: Data, publicKey: PublicKey) -> Data?
    static func decrypt(data: Data, privateKey: PrivateKey) -> Data?
}
