//
//  WeatherData+CoreDataClass.swift
//  WeatherApp
//
//  Created by Данил Толстиков on 10.04.2025.
//
//

import Foundation
import CoreData

@objc(WeatherData)
public class WeatherData: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let coreDataManager = CoreDataManager()
        self.init(entity: coreDataManager.entityForName("WeatherData"), insertInto: coreDataManager.context)
    }
}
