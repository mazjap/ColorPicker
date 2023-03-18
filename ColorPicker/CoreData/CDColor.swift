import CoreData
import Cocoa

class CDColor: NSManagedObject {
    static let separator = "|"
    static func srgbFrom(color: NSColor) -> String {
        let color = color.usingColorSpace(.sRGB) ?? color
        
        return srgbFrom(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: color.alphaComponent)
    }
    static func srgbFrom(red: Double, green: Double, blue: Double, alpha: Double) -> String {
        [red, green, blue, alpha].map { "\($0)" }.joined(separator: separator)
    }
    static func components(from srgb: String) -> [Double] {
        Array((srgb.components(separatedBy: separator).map { Double($0) ?? 0 } + [0, 0, 0, 0]).prefix(upTo: 4))
    }
    
    @NSManaged var name: String
    @NSManaged var srgb: String
    @NSManaged var dateAdded: Date
    
    var rgba: [Double] {
        Self.components(from: srgb)
    }
    
    convenience init(srgb: String, name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.srgb = srgb
        self.name = name
        self.dateAdded = Date()
    }
    
    var red: Double {
        rgba[0]
    }
    var green: Double {
        rgba[1]
    }
    var blue: Double {
        rgba[2]
    }
    var alpha: Double {
        rgba[3]
    }
    
    var color: NSColor {
        NSColor(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
}
