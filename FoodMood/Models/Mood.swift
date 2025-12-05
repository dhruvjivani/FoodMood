//
//  Mood.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import SwiftUI
import Combine

enum Mood: String, CaseIterable, Identifiable {
    case happy
    case sad
    case neutral
    case excited
    case tired

    var id: String { self.rawValue }

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😢"
        case .neutral: return "😐"
        case .excited: return "🤩"
        case .tired: return "😴"
        }
    }
}
