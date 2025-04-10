import CoreData

protocol CoreDataManagerProtocol {
    func saveWeather(_ weather: ViewData.Weather)
    func getWeather() -> [ViewData.Weather]
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    func entityForName(_ entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context) ?? NSEntityDescription()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveWeather(_ weather: ViewData.Weather) {
        let managedObject = WeatherData(entity: entityForName("WeatherData"), insertInto: context)
        managedObject.city = weather.city
        managedObject.condition = weather.condition
        managedObject.icon = weather.icon
        managedObject.temp = weather.temp
        managedObject.time = weather.time
        saveContext()
    }
    
    func getWeather() -> [ViewData.Weather] {
        var array = [ViewData.Weather]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
        do {
            let results = try context.fetch(fetchRequest) as? [WeatherData]
            for result in results ?? [] {
                array.append(ViewData.Weather(time: result.time ?? "",
                                              city: result.city ?? "",
                                              temp: result.temp,
                                              condition: result.condition ?? "",
                                              icon: result.icon ?? Data()))
            }
            
        } catch {
            print("Error")
        }
        return array
    }

}

