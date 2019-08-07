import Foundation

public extension Data {
    func toUInt64Array() -> [UInt64] {
        return splitEach(8).map { UInt64(littleEndian: Data($0).withUnsafeBytes { $0.pointee }) }
    }
    
    func toString() -> String? {
        return String(bytes: self, encoding: .utf8)
    }
}

extension Data: BinaryEncodable {
    public init?(raw: [Bool]) {
        self.init(raw.toBytes())
    }
    
    public func toBoolArray() -> [Bool] {
        return [UInt8](self).toBoolArray()
    }
}

public extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }
            .joined()
    }
}
