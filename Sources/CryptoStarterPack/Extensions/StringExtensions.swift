import Foundation

extension String: BinaryEncodable {
    public func toBoolArray() -> [Bool] {
        return data(using: .utf8)!.toBoolArray()
    }
    
    public init?(raw: [Bool]) {
        guard let string = String(bytes: raw.toBytes(), encoding: .utf8) else { return nil }
        self = string
    }
}

public extension String {
    var hexStringToData: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
}

public extension String {
    func bools() -> [Bool] {
        return map { $0 == "0" ? false : true }
    }
}

extension String: Stringable {
    public func toString() -> String {
        return self
    }
    
    public init?(stringValue: String) {
        self = stringValue
    }
}
