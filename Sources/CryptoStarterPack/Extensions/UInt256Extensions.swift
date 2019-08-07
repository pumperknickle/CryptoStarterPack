import Foundation

extension UInt256: BinaryEncodable {
    public func toBoolArray() -> [Bool] {
        return parts.toByteArray().toBoolArray()
    }
    
    public init?(raw: [Bool]) {
        self = UInt256(raw.toBytes().toUInt64Array())
    }
}

extension UInt256: Stringable {
    public func toString() -> String {
        return literal()!
    }
    
    public init?(stringValue: String) {
        self.init(raw: stringValue.bools())
    }
}

public extension UInt256 {
    func literal() -> String? {
        return toBoolArray().literal()
    }
}

extension UInt256: BinaryInteger {
    public typealias Words = [UInt]
    
    public static var isSigned: Bool {
        return false
    }
    
    public var words: [UInt] {
        var result = [UInt]()
        for value in parts.reversed() {
            result.append(contentsOf: value.words)
        }
        return result
    }
    
    public static var bitWidth: Int {
        return 256
    }
    
    public var bitWidth: Int {
        return UInt256.bitWidth
    }
    
    public var trailingZeroBitCount: Int {
        var result: Int = 0
        for value in parts.reversed() {
            let count = value.trailingZeroBitCount
            if count == 0 {
                return result
            }
            result += count
            if count < 64 {
                return result
            }
        }
        return result
    }
    
    public init<T>(_ source: T) where T: BinaryFloatingPoint {
        self.init(withUInt64: UInt64(source))
    }
    
    public init?<T>(exactly source: T) where T: BinaryFloatingPoint {
        if let uint64 = UInt64(exactly: source) {
            self.init(withUInt64: uint64)
        } else {
            return nil
        }
    }
    
    public init<T: BinaryInteger>(clamping source: T) {
        self.init(withUInt64: UInt64(clamping: source))
    }
    
    public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
        self.init(withUInt64: UInt64(truncatingIfNeeded: source))
    }
    
    static func leftShift(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        guard rhs < 256 else {
            return UInt256(0)
        }
        let modulus = Int(rhs[3] & 0x00FF)
        let remainder = modulus % 64
        let multiple = (modulus - remainder) / 64
        
        var result: [UInt64] = []
        for i in multiple ..< 4 {
            var value: UInt64 = lhs[i] << remainder
            if i < 3 {
                value |= lhs[i + 1] >> (64 - remainder)
            }
            result.append(value)
        }
        
        for _ in 0 ..< multiple {
            result.append(0)
        }
        
        return UInt256(result)
    }
    
    public static func << (lhs: UInt256, rhs: Int) -> UInt256 {
        return leftShift(lhs, UInt256(rhs))
    }
    
    public static func << <T: BinaryInteger>(lhs: UInt256, rhs: T) -> UInt256 {
        return leftShift(lhs, UInt256(rhs))
    }
    
    public static func <<=< T: BinaryInteger > (lhs: inout UInt256, rhs: T) {
        lhs = leftShift(lhs, UInt256(rhs))
    }
    
    public static func << (lhs: UInt256, rhs: UInt256) -> UInt256 {
        return leftShift(lhs, rhs)
    }
    
    public static func <<= (lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs << rhs
    }
    
    static func rightShift(_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        guard rhs < 256 else {
            return UInt256(0)
        }
        let modulus = Int(rhs[3] & 0x00FF)
        let remainder = modulus % 64
        let multiple = modulus / 64
        
        var result: [UInt64] = []
        for _ in 0 ..< multiple {
            result.append(0)
        }
        for i in 0 ..< 4 - multiple {
            var value: UInt64 = lhs[i] >> remainder
            if i > 0 {
                value |= lhs[i - 1] << (64 - remainder)
            }
            result.append(value)
        }
        
        return UInt256(result)
    }
    
    public static func >> (lhs: UInt256, rhs: Int) -> UInt256 {
        return rightShift(lhs, UInt256(rhs))
    }
    
    public static func >> <T: BinaryInteger>(lhs: UInt256, rhs: T) -> UInt256 {
        return rightShift(lhs, UInt256(rhs))
    }
    
    public static func >>= <T: BinaryInteger>(lhs: inout UInt256, rhs: T) {
        lhs = rightShift(lhs, UInt256(rhs))
    }
    
    public static func >> (lhs: UInt256, rhs: UInt256) -> UInt256 {
        return rightShift(lhs, rhs)
    }
    
    public static func >>= (lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs >> rhs
    }
    
    public static func & (lhs: UInt256, rhs: UInt256) -> UInt256 {
        return UInt256([
            lhs[0] & rhs[0],
            lhs[1] & rhs[1],
            lhs[2] & rhs[2],
            lhs[3] & rhs[3],
            ])
    }
    
    public static func &= (lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs & rhs
    }
    
    public static func ^ (lhs: UInt256, rhs: UInt256) -> UInt256 {
        return UInt256([
            lhs[0] ^ rhs[0],
            lhs[1] ^ rhs[1],
            lhs[2] ^ rhs[2],
            lhs[3] ^ rhs[3],
            ])
    }
    
    public static func ^= (lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs ^ rhs
    }
    
    public static func | (lhs: UInt256, rhs: UInt256) -> UInt256 {
        return UInt256([
            lhs[0] | rhs[0],
            lhs[1] | rhs[1],
            lhs[2] | rhs[2],
            lhs[3] | rhs[3],
            ])
    }
    
    public static func |= (lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs | rhs
    }
    
    public static prefix func ~ (lhs: UInt256) -> UInt256 {
        return UInt256([~lhs[0], ~lhs[1], ~lhs[2], ~lhs[3]])
    }
}

extension UInt256: Comparable {
    public static func < (lhs: UInt256, rhs: UInt256) -> Bool {
        for i in 0 ..< 4 {
            if lhs[i] < rhs[i] {
                return true
            } else if lhs[i] > rhs[i] {
                return false
            }
        }
        
        return false
    }
    
    public static func > (lhs: UInt256, rhs: UInt256) -> Bool {
        return rhs < lhs
    }
    
    public static func <= (lhs: UInt256, rhs: UInt256) -> Bool {
        return lhs == rhs || lhs < rhs
    }
    
    public static func >= (lhs: UInt256, rhs: UInt256) -> Bool {
        return lhs == rhs || lhs > rhs
    }
}

extension UInt256: Equatable {
    public static func == (_ lhs: UInt256, _ rhs: UInt256) -> Bool {
        return lhs[0] == rhs[0] &&
            lhs[1] == rhs[1] &&
            lhs[2] == rhs[2] &&
            lhs[3] == rhs[3]
    }
}

extension UInt256: CustomStringConvertible {
    public var description: String {
        return toHexString()
    }
}

extension UInt256: ExpressibleByIntegerLiteral {
    public init(integerLiteral: Int) {
        self.init(integerLiteral)
    }
}

extension UInt256: FixedWidthInteger {
    public init(_truncatingBits: UInt) {
        var result: [UInt64] = []
        for i in 0 ..< 4 {
            let bits = _truncatingBits >> (i * 64)
            result.append(UInt64(_truncatingBits: bits))
        }
        self.init(withUInt64Array: result.reversed())
    }
    
    public init(bigEndian: UInt256) {
        self.init(bigEndian.parts)
    }
    
    /// initializer from a little endian representation of the number
    /// since swift's native unsigned integers use little endian,
    /// and UInt256 here use big endian, we need to reverse the bytes
    /// so that the little endian representation correctly reflects
    /// the reverse order of bytes
    ///
    /// - Parameter littleEndian: UInt256, little endian representation
    public init(littleEndian: UInt256) {
        let newParts = littleEndian.parts.reversed().map { $0.bigEndian }
        self.init(newParts)
    }
    
    public var bigEndian: UInt256 {
        return self
    }
    
    public var littleEndian: UInt256 {
        let newParts = parts.reversed().map { $0.bigEndian }
        return UInt256(newParts)
    }
    
    public var nonzeroBitCount: Int {
        return parts[0].nonzeroBitCount
            + parts[1].nonzeroBitCount
            + parts[2].nonzeroBitCount
            + parts[3].nonzeroBitCount
    }
    
    public var leadingZeroBitCount: Int {
        var result: Int = 0
        for value in parts {
            let count = value.leadingZeroBitCount
            if count == 0 {
                return result
            }
            result += count
            if count < 64 {
                return result
            }
        }
        return result
    }
    
    public var byteSwapped: UInt256 {
        return UInt256([
            parts[3].byteSwapped,
            parts[2].byteSwapped,
            parts[1].byteSwapped,
            parts[0].byteSwapped,
            ])
    }
    
    public func addingReportingOverflow(_ rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return UInt256.add(self, rhs)
    }
    
    public func subtractingReportingOverflow(_ rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        return UInt256.subtract(self, rhs)
    }
    
    public func multipliedReportingOverflow(by rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        let (high, low) = UInt256.karatsuba(self, rhs)
        if high > 0 {
            return (low, true)
        }
        return (low, false)
    }
    
    public func dividedReportingOverflow(by rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        guard rhs > 0 else {
            return (UInt256(self), true)
        }
        let (result, _) = UInt256.divisionWithRemainder(self, rhs)
        return (result, false)
    }
    
    public func remainderReportingOverflow(dividingBy rhs: UInt256) -> (partialValue: UInt256, overflow: Bool) {
        guard rhs > 0 else {
            return (UInt256(self), true)
        }
        let (_, result) = UInt256.divisionWithRemainder(self, rhs)
        return (result, false)
    }
    
    public func multipliedFullWidth(by other: UInt256) -> (high: UInt256, low: UInt256) {
        return UInt256.karatsuba(self, other)
    }
    
    public func dividingFullWidth(_ dividend: (high: UInt256, low: UInt256)) -> (quotient: UInt256, remainder: UInt256) {
        // the divisor needs to be `normalized` before applying divide and conquer algo
        let count = leadingZeroBitCount
        let (q1, r1) = UInt256.divideAndConquer(dividend, by: self << count)
        let (q0, r0) = UInt256.divisionWithRemainder(r1, self)
        let quotient = q1 << count + q0
        return (quotient, r0)
    }
}

extension UInt256: Hashable {
    public var hashValue: Int {
        return toHexString().hashValue
    }
}

public extension UInt256 {
    private typealias SplitResult = (
        aH: UInt256,
        aL: UInt256,
        bH: UInt256,
        bL: UInt256,
        N2: Int
    )
    
    /// Karatsuba multiplication of two equal length unsigned integers
    /// karatsuba algorithm is the divide and conquer algorithm for
    /// multiplications.
    /// it reduces a multiplication of length n to 3 multiplications
    /// of length n/2, plus some other operations (-, <<, +).
    /// the result is double of length of the operands at most
    ///
    /// - Parameters:
    ///   - lhs: first operand of the multiplication
    ///   - rhs: second operand of the multiplication
    /// - Returns: (high, low), the full width result of the multiplication
    public static func karatsuba(_ lhs: UInt256, _ rhs: UInt256) -> (high: UInt256, low: UInt256) {
        guard lhs > 0 && rhs > 0 else {
            return (0, 0)
        }
        
        guard lhs.leadingZeroBitCount < 192 || rhs.leadingZeroBitCount < 192 else {
            let (high: low2, low: low3) = lhs[3].multipliedFullWidth(by: rhs[3])
            return (high: 0, low: UInt256([low2, low3]))
        }
        
        let (aH, aL, bH, bL, N2) = splitOperands(a: lhs, b: rhs)
        
        let (_, u) = karatsuba(aH, bH)
        let (_, v) = karatsuba(aL, bL)
        var w = karatsuba(aH + aL, bH + bL)
        var overflow = false
        
        (w.low, overflow) = w.low.subtractingReportingOverflow(u)
        if overflow {
            w.high = w.high - 1
        }
        
        (w.low, overflow) = w.low.subtractingReportingOverflow(v)
        if overflow {
            w.high = w.high - 1
        }
        
        var high: UInt256 = 0
        var low: UInt256 = 0
        var carry: Bool
        
        switch N2 {
        case 128:
            let wH = UInt256([w.high[2], w.high[3], w.low[0], w.low[1]])
            let wL = UInt256([w.low[2], w.low[3], 0, 0])
            
            high = u + wH
            (low, carry) = v.addingReportingOverflow(wL)
            if carry {
                high += 1
            }
            
        default: // N2 == 64
            let uH = UInt256([u[2], u[3], 0, 0])
            let wM = UInt256([w.low[1], w.low[2], w.low[3], 0])
            low = uH + v
            (low, carry) = low.addingReportingOverflow(wM)
        }
        
        return (high, low)
    }
    
    private static func splitOperands(a: UInt256, b: UInt256) -> SplitResult {
        let leadingZeroBitCount = Swift.min(
            a.leadingZeroBitCount,
            b.leadingZeroBitCount
        )
        var result: SplitResult
        
        switch leadingZeroBitCount {
        case 0 ..< 128:
            result = (
                aH: UInt256([0, 0, a[0], a[1]]),
                aL: UInt256([0, 0, a[2], a[3]]),
                bH: UInt256([0, 0, b[0], b[1]]),
                bL: UInt256([0, 0, b[2], b[3]]),
                N2: 128
            )
        case 128 ..< 192:
            result = (
                aH: UInt256(a[2]),
                aL: UInt256(a[3]),
                bH: UInt256(b[2]),
                bL: UInt256(b[3]),
                N2: 64
            )
        default:
            // Range is cool, but switch doesn't recognize open
            // ranges, such as (192...) or (..<128), hence this
            // `default` case
            result = (0, a, 0, b, 64)
        }
        
        return result
    }
}

extension UInt256: Numeric {
    static func add(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var values = [UInt64]()
        var carry: UInt64 = 0
        for i in (0 ..< 4).reversed() {
            let (result1, overflow1) = lhs[i].addingReportingOverflow(rhs[i])
            let (result2, overflow2) = result1.addingReportingOverflow(carry)
            values.insert(result2, at: 0)
            if overflow1 || overflow2 {
                carry = 1
            } else {
                carry = 0
            }
        }
        
        let result = UInt256(values)
        let overflow = carry == 1
        return (result, overflow)
    }
    
    public static func &+ (lhs: UInt256, rhs: UInt256) -> UInt256 {
        let (result, _) = add(lhs, rhs)
        return result
    }
    
    public static func + (lhs: UInt256, rhs: UInt256) -> UInt256 {
        let (result, _) = add(lhs, rhs)
        return result
    }
    
    public static func += (_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs + rhs
    }
    
    static func subtract(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, Bool) {
        var values = [UInt64]()
        var carry: UInt64 = 0
        for i in (0 ..< 4).reversed() {
            let (result1, overflow1) = lhs[i].subtractingReportingOverflow(rhs[i])
            let (result2, overflow2) = result1.subtractingReportingOverflow(carry)
            values.insert(result2, at: 0)
            if overflow1 || overflow2 {
                carry = 1
            } else {
                carry = 0
            }
        }
        
        let result = UInt256(values)
        let overflow = carry == 1
        return (result, overflow)
    }
    
    public static func &- (_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (result, _) = subtract(lhs, rhs)
        return result
    }
    
    public static func - (_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (result, _) = subtract(lhs, rhs)
        return result
    }
    
    public static func -= (_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs - rhs
    }
    
    public static func * (_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (_, result) = karatsuba(lhs, rhs)
        return result
    }
    
    public static func *= (_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs * rhs
    }
    
    public static func / (_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (result, _) = divisionWithRemainder(lhs, rhs)
        return result
    }
    
    public static func /= (_ lhs: inout UInt256, _ rhs: UInt256) {
        lhs = lhs / rhs
    }
    
    public static func divisionWithRemainder(_ lhs: UInt256, _ rhs: UInt256) -> (UInt256, UInt256) {
        guard lhs > 0, rhs > 1 else {
            return (0, 0)
        }
        
        guard lhs >= rhs else {
            return (0, lhs)
        }
        
        var quotient: UInt256 = 0
        var remainder: UInt256 = lhs
        var partial: UInt256 = 1
        var chunk: UInt256 = rhs
        var trail: [(UInt256, UInt256)] = [(1, rhs)]
        
        while remainder - chunk >= chunk {
            chunk = chunk << 1
            partial = partial << 1
            trail.append((partial, chunk))
        }
        
        for (partial, chunk) in trail.reversed() {
            if remainder >= chunk {
                remainder -= chunk
                quotient += partial
            }
        }
        
        return (quotient, remainder)
    }
    
    public static func % (_ lhs: UInt256, _ rhs: UInt256) -> UInt256 {
        let (_, result) = divisionWithRemainder(lhs, rhs)
        return result
    }
    
    public static func %= (lhs: inout UInt256, rhs: UInt256) {
        lhs = lhs % rhs
    }
}

extension UInt256: UnsignedInteger {
    public static var max = UInt256([UInt64.max, UInt64.max, UInt64.max, UInt64.max])
    public static var min = UInt256([UInt64.min, UInt64.min, UInt64.min, UInt64.min])
    
    public var magnitude: UInt256 {
        return UInt256(parts)
    }
}

public extension UInt256 {
    /// Divide and conquer algorithm for division
    /// Top level algo. It uses two subroutines:
    /// divideAndConquer2By1 and divideAndConquer3By2
    ///
    /// - Parameters:
    ///   - dividend: (high: UInt256, low: UInt256)
    ///   - divisor: UInt256
    /// - Returns: (quotient: UInt256, remainder: UInt256)
    static func divideAndConquer(_ dividend: (high: UInt256, low: UInt256), by divisor: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        var (hi, lo) = dividend
        guard hi > 0 else {
            return divisionWithRemainder(dividend.low, divisor)
        }
        
        if hi > divisor { // throw away the overflown part
            hi = hi % divisor
        }
        
        return divideAndConquer2By1((hi, lo), by: divisor)
    }
    
    /// Divide And Conquer 2 By 1
    /// this algorithm is in charge of handling 2-by-1 scenarios.
    /// the algorithm divide the high and low components into two
    /// 3-by-2 divisions and pass them over to 3-by-2 algorithm
    /// to calculate
    ///
    /// - Parameters:
    ///   - dividend: (high: UInt256, low: UInt256)
    ///   - divisor: UInt256
    /// - Returns: (quotient: UInt256, remainder: UInt256)
    static func divideAndConquer2By1(_ dividend: (high: UInt256, low: UInt256), by divisor: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        let (hi, lo) = dividend
        
        guard hi > 0 else {
            return divisionWithRemainder(dividend.low, divisor)
        }
        
        let highDividend = (high: UInt256([0, 0, hi[0], hi[1]]), low: UInt256([hi[2], hi[3], lo[0], lo[1]]))
        let (q1, r1) = divideAndConquer3By2(highDividend, by: divisor)
        
        let lowDividend = (high: UInt256([0, 0, r1[0], r1[1]]), low: UInt256([r1[2], r1[3], lo[2], lo[3]]))
        let (q0, r0) = divideAndConquer3By2(lowDividend, by: divisor)
        
        let quotient = UInt256([q1[2], q1[3], 0, 0]) + q0
        let remainder = r0
        
        return (quotient, remainder)
    }
    
    /// Divide And Conquer 3 By 2
    /// This algorithm takes a 3-by-2 division and calculates the results
    /// 3-by-2 here means it's 384-by-256, i.e. 128 most significant bits
    /// of dividend.high are zeros (dividend.high.leadingZeroCount >= 128)
    ///
    /// - Parameters:
    ///   - dividend: (high: UInt256, low: UInt256)
    ///   - divisor: UInt256
    /// - Returns: (quotient: UInt256, remainder: UInt256)
    static func divideAndConquer3By2(_ dividend: (high: UInt256, low: UInt256), by divisor: UInt256) -> (quotient: UInt256, remainder: UInt256) {
        let (hi, lo) = dividend
        
        guard hi > 0 else {
            return divisionWithRemainder(dividend.low, divisor)
        }
        
        var q_: UInt256 = 0
        var r1: UInt256 = 0
        let b1 = UInt256([0, 0, divisor[0], divisor[1]])
        if hi < b1 {
            let highDividend = UInt256([hi[2], hi[3], lo[0], lo[1]])
            (q_, r1) = divisionWithRemainder(highDividend, b1)
        } else {
            q_ = UInt256([0, 0, UInt64.max, UInt64.max])
            let diff = hi - b1
            r1 = UInt256([diff[2], diff[3], lo[0], lo[1]]) + b1
        }
        
        let overflow = r1[1] > 0
        let lowDividend = UInt256([r1[2], r1[3], lo[2], lo[3]])
        let b0 = UInt256([0, 0, divisor[2], divisor[3]])
        var (remainder, subOverflow) = lowDividend.subtractingReportingOverflow(q_ * b0)
        var quotient = q_
        if !overflow, subOverflow {
            let addOverflow: Bool
            quotient = quotient - 1
            (remainder, addOverflow) = remainder.addingReportingOverflow(divisor)
            if !addOverflow {
                quotient = quotient - 1
                remainder = remainder + divisor
            }
        }
        
        return (quotient, remainder)
    }
}
