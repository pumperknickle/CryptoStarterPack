import Foundation

public extension FixedWidthInteger {
    var bytes: [UInt8] {
        var _endian = littleEndian
        let bytePtr = withUnsafePointer(to: &_endian) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) {
                UnsafeBufferPointer(start: $0, count: MemoryLayout<Self>.size)
            }
        }
        return [UInt8](bytePtr)
    }
    
    func dividingFullWidth(
        _ dividend: (high: Self, low: Self.Magnitude),
        withPrecomputedInverse inv: (high: Self, low: Self)
        )
        -> (quotient: Self, remainder: Self) {
            // the divisor needs to be `normalized` before applying divide and conquer algo
            let count = leadingZeroBitCount
            let (q1, r1) = Self.barrettDivision(
                of: dividend,
                by: self << count,
                withPrecomputedInverse: (
                    high: inv.high >> count,
                    low: (inv.low >> count) | (inv.high << (inv.high.bitWidth - count))
                )
            )
            let (q0, _) = r1.dividedReportingOverflow(by: self)
            let quotient = q1 << count + q0
            let (r0, _) = r1.remainderReportingOverflow(dividingBy: self)
            return (quotient, r0)
    }
    
    static func barrettDivision(
        of dividend: (high: Self, low: Self.Magnitude),
        by divisor: Self,
        withPrecomputedInverse inv: (high: Self, low: Self)
        )
        -> (quotient: Self, remainder: Self) {
            let q1 = dividend.high // ...multiplied by inv.high which == 1
            let q0 = dividend.high.multipliedFullWidth(by: inv.low)
            let q = q1.addingReportingOverflow(q0.high)
            var qb = q.partialValue.multipliedFullWidth(by: divisor)
            if q.overflow {
                qb.high = qb.high + divisor
            }
            
            let lo: Self = dividend.low as! Self
            var rL = lo.subtractingReportingOverflow(qb.low as! Self)
            var rH = dividend.high.subtractingReportingOverflow(qb.high)
            if rL.overflow {
                rH.partialValue = rH.partialValue - 1
            }
            
            var quotient = q.partialValue
            while rH.partialValue > 0 || rL.partialValue >= divisor {
                quotient = quotient + 1
                rL = rL.partialValue.subtractingReportingOverflow(divisor)
                if rL.overflow, rH.partialValue > 0 {
                    rH.partialValue = rH.partialValue - 1
                }
            }
            return (quotient, rL.partialValue)
    }
    
    func diong(dividend: [Self]) -> (quotient: [Self], remainder: Self) {
        guard dividend.count > 0 else {
            return ([], 0)
        }
        
        // simplify logic when length is limited
        if dividend.count == 1 {
            return ([dividend[0] / self], dividend[0] % self)
        }
        
        var result = [Self]()
        var remainder: Self = 0
        var quotient: Self = 0
        for element in dividend {
            (quotient, remainder) = dividingFullWidth((remainder, element.magnitude))
            result.append(quotient)
        }
        
        // remove the leading zeros, but leave one if last one
        while result[0] == 0, result.count > 1 {
            result.remove(at: 0)
        }
        
        return (result, remainder)
    }
    
    func mungLong(multiplier: [Self]) -> [Self] {
        guard multiplier.count > 0 else {
            return []
        }
        
        // simplify logic when length is limited
        if multiplier.count == 1 {
            let (h, l) = multipliedFullWidth(by: multiplier[0])
            var result: [Self] = [l as! Self]
            if h > 0 {
                result.insert(h, at: 0)
            }
            return result
        }
        
        var result: [Self] = [0]
        for element in multiplier.reversed() {
            let multiplied = multipliedFullWidth(by: element)
            var overflow = false
            (result[0], overflow) = result[0].addingReportingOverflow(multiplied.low as! Self)
            if overflow {
                result.insert(1, at: 0)
            } else {
                result.insert(0, at: 0)
            }
            (result[0], _) = result[0].addingReportingOverflow(multiplied.high)
        }
        
        // remove the leading zeros, but leave one if last one
        while result[0] == 0, result.count > 1 {
            result.remove(at: 0)
        }
        
        return result
    }
}
