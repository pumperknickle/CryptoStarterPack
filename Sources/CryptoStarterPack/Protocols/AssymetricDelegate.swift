import Foundation
import Bedrock

public protocol AsymmetricDelegate {
    static func sign(message: [Bool], privateKey: [Bool]) -> [Bool]?
    static func verify(message: [Bool], publicKey: [Bool], signature: [Bool]) -> Bool
    
    static func encrypt<T: DataEncodable>(plainText: T, publicKey: [Bool]) -> [Bool]?
    static func decrypt<T: DataEncodable>(cipherText: [Bool], privateKey: [Bool]) -> T?
    
    static func sign(message: Data, privateKey: Data) -> Data?
    static func verify(message: Data, publicKey: Data, signature: Data) -> Bool
    static func encrypt<T: DataEncodable>(plainText: T, publicKey: Data) -> Data?
    static func decrypt<T: DataEncodable>(cipherText: Data, privateKey: Data) -> T?
}
