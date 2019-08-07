import Foundation

public extension Array {
    static func - (left: Array, right: Array) -> Array {
        return Array(left.dropFirst(right.count))
    }
}

public extension Array where Element: Equatable {
    static func ~> (left: Array, right: Array) -> Array {
        guard let leftFirst = left.first else { return [] }
        guard let rightFirst = right.first else { return [] }
        if leftFirst != rightFirst { return [] }
        return [leftFirst] + (Array(left.dropFirst()) ~> Array(right.dropFirst()))
    }
}

public extension Array where Element: Comparable {
    static func < (lhs: [Element], rhs: [Element]) -> Bool {
        guard let firstLeft = lhs.first else { return true }
        guard let firstRight = rhs.first else { return false }
        if firstLeft == firstRight { return Array(lhs.dropFirst()) < Array(rhs.dropFirst()) }
        return firstLeft < firstRight
    }
}

public extension Array where Element == Bool {
    func toBytes() -> [UInt8] {
        let numBits = count
        let numBytes = (numBits + 7) / 8
        var bytes = [UInt8](repeating: 0, count: numBytes)
        
        for (index, bit) in enumerated() {
            if bit == true {
                bytes[index / 8] += 1 << (7 - index % 8)
            }
        }
        return bytes
    }
    
    func literal() -> String {
        return map { $0 ? "1" : "0" }.reduce("", +)
    }
}
