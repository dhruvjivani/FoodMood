//
//  LogEntry+CoreDataProperties.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//
//

import Foundation
import CoreData

extension LogEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LogEntry> {
        return NSFetchRequest<LogEntry>(entityName: "LogEntry")
    }

    @NSManaged public var mealName: String?
    @NSManaged public var mood: String?
    @NSManaged public var calories: Int64
    @NSManaged public var notes: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var aiPrediction: String?
}
