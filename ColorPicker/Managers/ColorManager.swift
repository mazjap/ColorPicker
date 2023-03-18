import CoreData
import AppKit.NSColor

class ColorManager: ObservableObject {
    @discardableResult
    func save(color: NSColor, customName name: String? = nil, context: NSManagedObjectContext) throws -> CDColor {
        let color = color.usingColorSpace(.sRGB) ?? color
        let srgb = CDColor.srgbFrom(color: color)
        
        let request = CDColor.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "srgb == %@", srgb)
        
        if let item = try self.color(for: srgb, context: context) {
            item.dateAdded = Date()
            try context.save()
            return item
        }
        
        return CDColor(srgb: srgb, name: name ?? color.accessibilityName, context: context)
    }
    
    func color(for srgb: String, context: NSManagedObjectContext) throws -> CDColor? {
        let request = CDColor.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "srgb == %@", srgb)
        
        return try context.fetch(request).first as? CDColor
    }
    
    func color(for color: NSColor, context: NSManagedObjectContext) throws -> CDColor? {
        try self.color(for: CDColor.srgbFrom(color: color), context: context)
    }
    
    private func colorExists(_ srgb: String, context: NSManagedObjectContext) throws -> Bool {
        try color(for: srgb, context: context) != nil
    }
    
    func colorExists(_ color: NSColor, context: NSManagedObjectContext) throws -> Bool {
        try colorExists(CDColor.srgbFrom(color: color), context: context)
    }
    
    func delete(color: CDColor, context: NSManagedObjectContext) throws {
        context.delete(color)
        try context.save()
    }
}
