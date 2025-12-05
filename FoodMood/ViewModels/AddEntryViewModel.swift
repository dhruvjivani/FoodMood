//
//  AddEntryViewModel.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import Foundation
import SwiftUI
internal import CoreData
import Combine

@MainActor
final class AddEntryViewModel: ObservableObject {

    // Required for ObservableObject
    let objectWillChange = ObservableObjectPublisher()

    // Form fields
    @Published var mealName: String = ""
    @Published var mood: Mood = .happy
    @Published var calories: Int = 200
    @Published var notes: String = ""
    @Published var date: Date = Date()
    
    @Published var image: UIImage? = nil
    @Published var aiPrediction: String = ""

    // UI Alerts
    @Published var showValidationError = false
    @Published var validationMessage = ""

    let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func validateForm() -> Bool {
        if mealName.trimmingCharacters(in: .whitespaces).isEmpty {
            validationMessage = "Meal name is required."
            return false
        }
        return true
    }

    func saveEntry() {
        guard validateForm() else {
            showValidationError = true
            return
        }

        let newEntry = LogEntry(context: viewContext)
        newEntry.mealName = mealName
        newEntry.mood = mood.rawValue       // ✅ FIX HERE
        newEntry.calories = Int64(Int32(calories))
        newEntry.notes = notes
        newEntry.date = date
        newEntry.aiPrediction = aiPrediction
        newEntry.imageData = image?.jpegData(compressionQuality: 0.8)

        do {
            try viewContext.save()
            print("Entry saved successfully!")
        } catch {
            print("Error saving entry: \(error.localizedDescription)")
        }
    }
}
