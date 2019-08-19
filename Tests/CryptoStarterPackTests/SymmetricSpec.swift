import Foundation
import Nimble
import Quick
@testable import CryptoStarterPack

final class SymmetricSpec: QuickSpec {
    override func spec() {
        describe("AES 256 bit CBC Mode") {
            it("encrypts and decrypts back into the same plaintext") {
                let plainText = "hello world".data(using: .utf8)!
                let key = UInt64.random(in: 0..<UInt64.max).bytes + UInt64.random(in: 0..<UInt64.max).bytes + UInt64.random(in: 0..<UInt64.max).bytes + UInt64.random(in: 0..<UInt64.max).bytes
                let iv = UInt64.random(in: 0..<UInt64.max).bytes + UInt64.random(in: 0..<UInt64.max).bytes
                let cipherText = BaseSymmetric.encrypt(data: plainText, key: Data(key), iv: Data(iv))
                expect(cipherText).toNot(beNil())
                let decrypted = BaseSymmetric.decrypt(data: cipherText!, key: Data(key), iv: Data(iv))
                expect(decrypted).toNot(beNil())
                expect(decrypted!).to(equal(plainText))
            }
        }
    }
}
