import CoreData

class ExportFormat: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var expression: String
    
    convenience init(name: String, expression: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.expression = expression
    }
    
    var format: ColorFormat? {
        guard let data = expression.data(using: .utf8) else { return nil }
        
        return autoreleasepool { try? JSONDecoder().decode(ColorFormat.self, from: data) }
    }
}
