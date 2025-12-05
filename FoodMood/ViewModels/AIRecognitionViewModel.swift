//
//  AIRecognitionViewModel.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AIRecognitionViewModel: ObservableObject {

    @Published var prediction: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    func analyze(image: UIImage) async {
        isLoading = true

        do {
            let result = try await CoreMLManager.shared.predictFood(from: image)
            prediction = result
        } catch {
            showError = true
            errorMessage = "Prediction failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// Clear previous predictions.
    func reset() {
        prediction = ""
        showError = false
        errorMessage = ""
    }
}
