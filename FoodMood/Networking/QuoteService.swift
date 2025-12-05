//
//  QuoteService.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import Foundation

struct QuoteService {

    static let shared = QuoteService()

    private let urlString = "https://zenquotes.io/api/today"

    func fetchDailyQuote() async throws -> Quote {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse {
            if !(200...299).contains(httpResponse.statusCode) {
                throw APIError.serverError(httpResponse.statusCode)
            }
        }

        do {
            let decoded = try JSONDecoder().decode([Quote].self, from: data)
            if let quote = decoded.first {
                return quote
            }
            throw APIError.decodingFailed
        } catch {
            throw APIError.decodingFailed
        }
    }
}
