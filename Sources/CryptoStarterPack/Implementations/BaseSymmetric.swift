import Foundation
import Bedrock
import Crypto
import CryptoSwift

public struct BaseSymmetric: SymmetricDelegate {
    public typealias Key = UInt256
	public typealias IV = UInt128
	
	private static let defaultIV = UInt128(UInt64.min + UInt64.min)
    
	public static func encrypt(plainText: [Bool], key: Key, iv: IV? = nil) -> [Bool]? {
        return try! Data.convert(plainText).encrypt(cipher: AES(key: key.toData().bytes, blockMode: CBC(iv: iv != nil ? iv!.toData().bytes : defaultIV.toData().bytes))).toBoolArray()
    }
    
	public static func decrypt(cipherText: [Bool], key: Key, iv: IV? = nil) -> [Bool]? {
        guard let ciphertextData = Data(raw: cipherText) else { return nil }
        guard let plaintextData = try? AES(key: key.toData().bytes, blockMode: CBC(iv: iv != nil ? iv!.toData().bytes : defaultIV.toData().bytes)).decrypt(ciphertextData.bytes) else { return nil }
        return Data(plaintextData).convert()
    }
}

extension Data: Randomizable {
	public static func random() -> Self {
		return Data(UInt64.random(in: 0...UInt64.max).bytes + UInt64.random(in: 0...UInt64.max).bytes)
	}
}
