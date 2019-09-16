import Foundation
import Nimble
import Quick
@testable import CryptoStarterPack

final class SymmetricSpec: QuickSpec {
    override func spec() {
        describe("AES 256 bit CBC Mode") {
            it("encrypts and decrypts back into the same plaintext") {
                let plainText = "hello world"
                let key = UInt256.random()
                let cipherText = BaseSymmetric.encrypt(plaintext: plainText, key: key)
                expect(cipherText).toNot(beNil())
                let decrypted: String? = BaseSymmetric.decrypt(ciphertext: cipherText!, key: key)
                expect(decrypted).toNot(beNil())
                expect(decrypted!).to(equal(plainText))
            }
        }
    }
}
