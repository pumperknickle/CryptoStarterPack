import Foundation
import Bedrock

public protocol SymmetricDelegate {
    associatedtype Key: Stringable, Randomizable, DataEncodable
	associatedtype IV: DataEncodable, Randomizable, Fixed
    static func encrypt<T: DataEncodable>(plaintext: T, key: Key, iv: IV?) -> Data?
    static func decrypt<T: DataEncodable>(cipherText: T, key: Key, iv: IV?) -> Data?
	static func encrypt(plainText: [Bool], key: Key, iv: IV?) -> [Bool]?
	static func decrypt(cipherText: [Bool], key: Key, iv: IV?) -> [Bool]?
}
