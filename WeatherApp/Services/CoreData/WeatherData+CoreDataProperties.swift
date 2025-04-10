//
//  WeatherData+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Данил Толстиков on 10.04.2025.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var time: String?
    @NSManaged public var city: String?
    @NSManaged public var temp: Double
    @NSManaged public var condition: String?
    @NSManaged public var icon: Data?

}

extension WeatherData : Identifiable {

}
