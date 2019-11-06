import Foundation
import Bedrock
import Crypto

public struct BaseSymmetric: SymmetricDelegate {
    public typealias Key = UInt256
	public typealias IV = UInt128
	
	private static let defaultIV = UInt128(UInt64.min + UInt64.min)
    
	public static func encrypt(plainText: [Bool], key: Key, iv: IV? = nil) -> [Bool]? {
        guard let plaintextData = plainText.literal().data(using: .utf8) else { return nil }
		return try? AES256CBC.encrypt(plaintextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: iv != nil ? iv!.toData() : defaultIV.toData()).toBoolArray()
    }
    
	public static func decrypt(cipherText: [Bool], key: Key, iv: IV? = nil) -> [Bool]? {
        guard let ciphertextData = Data(raw: cipherText) else { return nil }
		guard let plaintextData = try? AES256CBC.decrypt(ciphertextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: iv?.toData() ?? defaultIV.toData()) else { return nil }
		return String(bytes: plaintextData, encoding: .utf8)?.bools()
    }
}

extension Data: Randomizable {
	public static func random() -> Self {
		return Data(UInt64.random(in: 0...UInt64.max).bytes + UInt64.random(in: 0...UInt64.max).bytes)
	}
}
