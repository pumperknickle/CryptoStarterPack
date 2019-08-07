import Foundation

public protocol CryptoHashable {
    associatedtype Digest: FixedWidthInteger, Stringable
    func hash() -> Digest?
}
