import Foundation
import Crypto

public protocol SymmetricDelegate {
    static func encrypt(data: Data, key: Data, iv: Data) -> Data?
    static func decrypt(data: Data, key: Data, iv: Data) -> Data?
}
