import Cocoa

extension NSColor {
    convenience init?(_ hexString: String) {
        guard !hexString.isEmpty else { return nil }
        
        let withoutPound = String(hexString[(hexString.first == "#"
             ? hexString.index(after: hexString.startIndex)
             : hexString.startIndex)...])
            .uppercased()
        
        switch withoutPound.count {
        case 2:
            self.init(withoutPound + withoutPound + withoutPound + "FF")
            return
        case 3:
            self.init(withoutPound + "F")
            return
        case 4:
            let rStr = withoutPound[withoutPound.startIndex]
            let gStr = withoutPound[withoutPound.index(after: withoutPound.startIndex)]
            let bStr = withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 2)]
            let aStr = withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 3)]
            
            self.init("\(rStr)\(rStr)\(gStr)\(gStr)\(bStr)\(bStr)\(aStr)\(aStr)")
            return
        case 6:
            self.init(withoutPound + "FF")
            return
        case 8:
            let r, g, b, a: Double
            
            let rStr = String(withoutPound[..<withoutPound.index(withoutPound.startIndex, offsetBy: 2)])
            let gStr = String(withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 2)..<withoutPound.index(withoutPound.startIndex, offsetBy: 4)])
            let bStr = String(withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 4)..<withoutPound.index(withoutPound.startIndex, offsetBy: 6)])
            let aStr = String(withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 6)...])
            guard let rInt = UInt8(rStr, radix: 16),
                  let gInt = UInt8(gStr, radix: 16),
                  let bInt = UInt8(bStr, radix: 16),
                  let aInt = UInt8(aStr, radix: 16)
            else { return nil }
            let max = Double(UInt8.max)
            r = Double(rInt) / max
            g = Double(gInt) / max
            b = Double(bInt) / max
            a = Double(aInt) / max
            
            self.init(red: r, green: g, blue: b, alpha: a)
        default:
            return nil
        }
    }
    
    var hexString: String {
        let max = CGFloat(UInt8.max)
        
        let red = String(UInt8(redComponent * max), radix: 16, uppercase: true)
        let green = String(UInt8(greenComponent * max), radix: 16, uppercase: true)
        let blue = String(UInt8(blueComponent * max), radix: 16, uppercase: true)
        let alpha = String(UInt8(alphaComponent * max), radix: 16, uppercase: true)
        
        return "#\(red)\(green)\(blue)\(alpha)"
    }
}
