import Foundation
import Bedrock

public protocol CryptoHashable {
    associatedtype Digest: FixedWidthInteger, Stringable
    func hash() -> Digest?
}
