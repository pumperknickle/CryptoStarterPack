import Foundation
import Crypto

public struct BaseSymmetric: SymmetricDelegate {
    public static func encrypt(data: Data, key: Data, iv: Data) -> Data? {
        return try? AES256CBC.encrypt(data, key: key, iv: iv)
    }
    
    public static func decrypt(data: Data, key: Data, iv: Data) -> Data? {
        return try? AES256CBC.decrypt(data, key: key, iv: iv)
    }
}
