import Foundation
import Nimble
import Quick
import Bedrock
@testable import CryptoStarterPack

final class SymmetricSpec: QuickSpec {
    override func spec() {
        describe("AES 256 bit CBC Mode") {
            it("encrypts and decrypts back into the same plaintext") {
                let plainText = "hello world".toBoolArray()
                let key = UInt256.random()
                let cipherText = BaseSymmetric.encrypt(plainText: plainText, key: key)
                expect(cipherText).toNot(beNil())
                let decrypted = BaseSymmetric.decrypt(cipherText: cipherText!, key: key)
                expect(decrypted).toNot(beNil())
                expect(decrypted!).to(equal(plainText))
            }
        }
    }
}
