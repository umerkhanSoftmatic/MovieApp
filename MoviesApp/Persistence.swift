import CoreData


struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MoviesApp")
        if inMemory {
            if let description = container.persistentStoreDescriptions.first {
                description.url = URL(fileURLWithPath: "/dev/null")
            } else {
                fatalError("Failed to find a persistent store description.")
            }
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}




// Temporary container to just fetch data from Api , avoiding to store that in CoreData
class CoreDataStack {
  static let shared = CoreDataStack()
  private init() {}
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MoviesApp")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}
