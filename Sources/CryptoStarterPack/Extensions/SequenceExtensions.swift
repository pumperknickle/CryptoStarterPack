import Foundation

public extension Sequence {
    func splitEach(_ clump: Int) -> [[Self.Element]] {
        return reduce(into: []) { memo, cur in
            if memo.count == 0 {
                return memo.append([cur])
            }
            if memo.last!.count < clump {
                memo.append(memo.removeLast() + [cur])
            } else {
                memo.append([cur])
            }
        }
    }
}

public extension Sequence where Element == UInt8 {
    func toUInt64Array() -> [UInt64] {
        return splitEach(8).map { UInt64(littleEndian: Data(bytes: $0).withUnsafeBytes { $0.pointee }) }
    }
    
    func toString() -> String? {
        return String(bytes: self, encoding: .utf8)
    }
}

public extension Sequence where Element == UInt64 {
    func toByteArray() -> [UInt8] {
        return map { $0.bytes }.reduce([], +)
    }
}
