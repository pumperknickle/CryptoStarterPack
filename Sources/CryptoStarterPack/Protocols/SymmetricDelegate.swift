import Foundation
import Crypto

public protocol SymmetricDelegate {
    associatedtype Key: Stringable, Randomizable
    static func encrypt<T: BinaryEncodable>(plaintext: T, key: Key) -> [Bool]?
    static func decrypt<T: BinaryEncodable>(ciphertext: [Bool], key: Key) -> T?
}
