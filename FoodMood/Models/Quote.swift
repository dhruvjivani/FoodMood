//
//  Quote.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import Foundation

struct Quote: Codable {
    let q: String   // quote text
    let a: String   // author
}

struct QuoteResponse: Codable {
    let quotes: [Quote]
}
