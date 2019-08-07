import Foundation

extension UInt8: BinaryEncodable {
    public init?(raw: [Bool]) {
        var byte = UInt8(0)
        for (index, bit) in raw.enumerated() {
            if bit == true {
                byte += 1 << (7 - index % 8)
            }
        }
        self = byte
    }
    
    public func toBoolArray() -> [Bool] {
        var byte = self
        var bits = [Bool](repeating: false, count: 8)
        for i in 0 ..< 8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[7 - i] = true
            }
            byte >>= 1
        }
        return bits
    }
}
