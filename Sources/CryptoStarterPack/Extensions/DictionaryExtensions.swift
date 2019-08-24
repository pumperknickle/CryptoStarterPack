import Foundation

public extension Dictionary {
    func removing(_ key: Key) -> [Key: Value] {
        return filter { $0.key != key }
    }
    
    func merging(_ dict: [Key: Value]) -> [Key: Value] {
        return reduce(dict) { (result, tuple) -> [Key: Value] in
            result.setting(tuple.key, withValue: tuple.value)
        }
    }
    
    func setting(_ key: Key, withValue value: Value) -> [Key: Value] {
        return merging([key: value]) { _, new in new }
    }
}

public extension Dictionary where Value == [[String]] {
    func prepend(_ key: String) -> [Key: [[String]]] {
        return reduce([:] as [Key: [[String]]]) { (result, entry) -> [Key: [[String]]] in
            result.setting(entry.key, withValue: entry.value.map { [key] + $0 })
        }
    }
    
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        return rhs.reduce(lhs) { (result, entry) -> [Key: Value] in
            guard let current = result[entry.key] else { return result.setting(entry.key, withValue: entry.value) }
            return result.setting(entry.key, withValue: entry.value + current)
        }
    }
}

public extension Dictionary where Key: Stringable, Value: Stringable {
    func toSortedKeys() -> [Key] {
        return sorted { $0.key < $1.key }.map { $0.key }
    }
    
    func toSortedValues() -> [Value] {
        return sorted { $0.key < $1.key }.map { $0.value }
    }
    
    static func combine(keys: [String], values: [String]) -> [Key: Value]? {
        let convertedKeys = keys.map { return Key(stringValue: $0) }
        let convertedValues = values.map { return Value(stringValue: $0) }
        if convertedKeys.contains(nil) || convertedValues.contains(nil) || convertedKeys.count != convertedValues.count { return nil }
        let finalKeys = convertedKeys.map { $0! }
        if Set(finalKeys).count != finalKeys.count { return nil }
        return Dictionary.combine(keys: finalKeys, values: convertedValues.map { $0! })
    }
    
    static func combine(keys: [Key], values: [Value]) -> [Key: Value] {
        return Dictionary(uniqueKeysWithValues: zip(keys, values))
    }
}
