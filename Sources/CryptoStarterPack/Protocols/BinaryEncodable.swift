import Foundation

public protocol BinaryEncodable {
    func toBoolArray() -> [Bool]
    init?(raw: [Bool])
}

public extension Sequence where Element: BinaryEncodable {
    func toBoolArray() -> [Bool] {
        return map { $0.toBoolArray() }.reduce([], +)
    }
}

