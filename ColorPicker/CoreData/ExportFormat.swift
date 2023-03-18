import CoreData

class ExportFormat: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var expression: String
    
    convenience init(name: String, expression: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.expression = expression
    }
}
