import Cocoa

extension NSColor {
    enum HexError: Error {
        case unsupportedLength(length: Int)
        case unsupportedCharacter(String)
    }
    
    convenience init(_ hexString: String) throws {
        guard !hexString.isEmpty else {
            throw HexError.unsupportedLength(length: 0)
        }
        
        let withoutPound = String(hexString[(hexString.first == "#"
             ? hexString.index(after: hexString.startIndex)
             : hexString.startIndex)...]).uppercased()
        
        switch withoutPound.count {
        case 2:
            try self.init(withoutPound + withoutPound + withoutPound + "FF")
        case 3:
            try self.init(withoutPound + "F")
        case 4:
            let r = withoutPound[withoutPound.startIndex]
            let g = withoutPound[withoutPound.index(after: withoutPound.startIndex)]
            let b = withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 2)]
            let a = withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 3)]
            
            try self.init("\(r)\(r)\(g)\(g)\(b)\(b)\(a)\(a)")
        case 6:
            try self.init(withoutPound + "FF")
        case 8:
            let rStr = String(withoutPound[..<withoutPound.index(withoutPound.startIndex, offsetBy: 2)])
            let gStr = String(withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 2)..<withoutPound.index(withoutPound.startIndex, offsetBy: 4)])
            let bStr = String(withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 4)..<withoutPound.index(withoutPound.startIndex, offsetBy: 6)])
            let aStr = String(withoutPound[withoutPound.index(withoutPound.startIndex, offsetBy: 6)...])
            
            guard let rInt = UInt8(rStr, radix: 16) else {
                throw HexError.unsupportedCharacter(rStr)
            }
            
            guard let gInt = UInt8(gStr, radix: 16) else {
                throw HexError.unsupportedCharacter(gStr)
            }
            
            guard let bInt = UInt8(bStr, radix: 16) else {
                throw HexError.unsupportedCharacter(bStr)
            }
            
            guard let aInt = UInt8(aStr, radix: 16) else {
                throw HexError.unsupportedCharacter(aStr)
            }
            
            let max = Double(UInt8.max)
            let r = Double(rInt) / max
            let g = Double(gInt) / max
            let b = Double(bInt) / max
            let a = Double(aInt) / max
            
            self.init(red: r, green: g, blue: b, alpha: a)
        default:
            throw HexError.unsupportedLength(length: withoutPound.count)
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
    
    static var random: NSColor {
        [NSColor.red, .blue, .green, .purple, .orange, .white, .black, .brown, .clear, .cyan, .gray].randomElement() ?? .magenta
    }
}
