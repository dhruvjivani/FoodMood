//
//  LogRowView.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import SwiftUI
internal import CoreData
import UIKit

struct LogRowView: View {
    let entry: LogEntry

    var body: some View {
        HStack(spacing: 16) {
            if let image = entry.uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 55, height: 55)
                    .overlay {
                        Image(systemName: "photo")
                    }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.wrappedMealName)
                    .font(.headline)
                Text(entry.wrappedMood.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(DateFormatter.displayFormatter.string(from: entry.date ?? Date()))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}
