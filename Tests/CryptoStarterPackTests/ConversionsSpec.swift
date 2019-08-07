import Foundation
import Nimble
import Quick
@testable import CryptoStarterPack

final class BaseConversionsSpec: QuickSpec {
    override func spec() {
        describe("data to hex string conversions") {
            let random = "Hello world".data(using: .utf8)
            expect(random!.hexString.hexStringToData!).to(equal(random!))
        }
        describe("uint256 to string conversions") {
            let random = arc4random256()
            expect(UInt256(stringValue: random.literal()!)).to(equal(random))
        }
        describe("uint conversions") {
            let x256 = UInt256(123_121_112_315_982)
            it("should convert bytes to bits and back") {
                let randomBytes = x256.parts.map { $0.bytes }.reduce([], +)
                expect(randomBytes).to(equal(randomBytes.toBoolArray().toBytes()))
            }
            it("should convert between byte array and uint64 array") {
                let x64 = x256.parts
                let bools = x64.map { $0.bytes.toBoolArray() }.reduce([], +)
                expect(x64).to(equal(bools.toBytes().toUInt64Array()))
            }
            it("should convert uint256 to bits and back") {
                expect(UInt256(raw: x256.toBoolArray())!).to(equal(x256))
            }
        }
    }
}
