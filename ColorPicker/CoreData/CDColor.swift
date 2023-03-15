import CoreData
import Cocoa

class CDColor: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var rgb: [Double]
    @NSManaged var dateAdded: Date
    
    convenience init(color: NSColor, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = color.accessibilityName
        
        let color = color.usingColorSpace(.deviceRGB)!
        self.rgb = [color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent]
        self.dateAdded = Date()
    }
    
    var red: Double {
        rgb[0]
    }
    var green: Double {
        rgb[1]
    }
    var blue: Double {
        rgb[2]
    }
    var alpha: Double {
        rgb[3]
    }
    
    var color: NSColor {
        NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
