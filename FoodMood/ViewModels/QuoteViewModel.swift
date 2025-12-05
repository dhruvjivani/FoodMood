//
//  QuoteViewModel.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class QuoteViewModel: ObservableObject {

    @Published var quoteText: String = "Loading..."
    @Published var author: String = ""

    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    func fetchQuote() async {
        do {
            let quote = try await QuoteService.shared.fetchDailyQuote()
            quoteText = quote.q
            author = quote.a
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            quoteText = "Unable to load quote."
        }
    }
}
