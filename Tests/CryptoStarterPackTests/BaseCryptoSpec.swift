import Foundation
import Nimble
import Quick
@testable import CryptoStarterPack

final class BaseCryptoSpec: QuickSpec {
    override func spec() {
        describe("The SHA 256 hashing algorithm") {
            it("hashes a message into a 256 bit output") {
                expect(BaseCrypto.hash("The yellow fox crossed the road.".data(using: .utf8)!)).toNot(beNil())
                expect(BaseCrypto.hash("The yellow fox crossed the road.".data(using: .utf8)!.toBoolArray())).toNot(beNil())

            }
        }
    }
}
