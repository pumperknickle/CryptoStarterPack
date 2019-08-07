import Foundation

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        if !lhs, rhs { return true }
        return false
    }
}

extension Bool: BinaryEncodable {
    public func toBoolArray() -> [Bool] {
        return [self]
    }
    
    public init?(raw: [Bool]) {
        guard let firstBool = raw.first else { return nil }
        self = firstBool
    }
}

extension Bool: Stringable {
    public func toString() -> String {
        return self ? "1" : "0"
    }
    
    public init?(stringValue: String) {
        if stringValue != "0", stringValue != "1" { return nil }
        self = stringValue == "0" ? false : true
    }
}
