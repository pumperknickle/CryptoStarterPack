import Foundation
import Nimble
import Quick
import Bedrock
@testable import CryptoStarterPack

final class SymmetricSpec: QuickSpec {
    override func spec() {
        describe("AES 256 bit CBC Mode") {
            it("encrypts and decrypts back into the same plaintext") {
				let plainText = "hello world, this is a test to test the encryption and decryption of symmetric key cryptography algorithms".toBoolArray()
                let key = UInt256.random()
				let iv = Data.random()
                let cipherText = BaseSymmetric.encrypt(plainText: plainText, key: key, iv: iv)
                expect(cipherText).toNot(beNil())
                let decrypted = BaseSymmetric.decrypt(cipherText: cipherText!, key: key, iv: iv)
                expect(decrypted).toNot(beNil())
                expect(decrypted!).to(equal(plainText))
            }
        }
    }
}
