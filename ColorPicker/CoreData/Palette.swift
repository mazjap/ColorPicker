import CoreData

class Palette: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var colors_: NSOrderedSet
    
    convenience init(name: String, colors: [CDColor] = [], context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.colors_ = NSOrderedSet(array: colors)
    }
    
    var colors: [CDColor] {
        colors_.compactMap { $0 as? CDColor }
    }
}
