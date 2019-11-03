import Foundation
import Bedrock
import Crypto

public struct BaseSymmetric: SymmetricDelegate {
    public typealias Key = UInt256
	public typealias IV = Data
	
	private static let defaultIV = UInt64.min.bytes + UInt64.min.bytes
    
	public static func encrypt(plainText: [Bool], key: Key, iv: IV? = nil) -> [Bool]? {
        guard let plaintextData = plainText.literal().data(using: .utf8) else { return nil }
		guard let iv = iv else {
			return try? AES256CBC.encrypt(plaintextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: defaultIV).toBoolArray()
		}
		let cutIV = Array(iv.prefix(16))
		if cutIV.count < 16 { return nil }
		return try? AES256CBC.encrypt(plaintextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: cutIV).toBoolArray()
    }
    
	public static func decrypt(cipherText: [Bool], key: Key, iv: IV? = nil) -> [Bool]? {
        guard let ciphertextData = Data(raw: cipherText) else { return nil }
		guard let plaintextData = try? AES256CBC.decrypt(ciphertextData, key: key.parts[0].bytes + key.parts[1].bytes + key.parts[2].bytes + key.parts[3].bytes, iv: iv?.prefix(16) ?? defaultIV) else { return nil }
        guard let plaintextString = String(bytes: plaintextData, encoding: .utf8) else { return nil }
        return plaintextString.bools()
    }
}

extension Data: Randomizable {
	public static func random() -> Self {
		return Data(UInt64.random(in: 0...UInt64.max).bytes + UInt64.random(in: 0...UInt64.max).bytes)
	}
}
