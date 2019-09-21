import Foundation
import Crypto

public protocol SymmetricDelegate {
    associatedtype Key: Stringable, Randomizable
    static func encrypt(plainText: [Bool], key: Key) -> [Bool]?
    static func decrypt(cipherText: [Bool], key: Key) -> [Bool]?
}
