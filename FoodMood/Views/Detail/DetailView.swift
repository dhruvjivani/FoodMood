//
//  DetailView.swift
//  FoodMood
//

import SwiftUI

struct DetailView: View {

    let entry: LogEntry
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteAlert = false
    @State private var showShare = false
    @State private var exportedURL: URL? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let image = entry.uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                }

                VStack(alignment: .leading, spacing: 8) {
                    detailRow(title: "Meal Name", value: entry.wrappedMealName)
                    detailRow(title: "Mood", value: entry.wrappedMood.rawValue)
                    detailRow(title: "Calories", value: "\(entry.calories)")
                    detailRow(title: "AI Prediction", value: entry.wrappedAIPrediction)
                    detailRow(title: "Date",
                              value: DateFormatter.displayFormatter.string(from: entry.date ?? Date()))
                }


                Text("Notes:")
                    .font(.headline)
                Text(entry.wrappedNotes)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Delete Entry", systemImage: "trash")
                }
                .padding(.top, 30)

                Button {
                    exportEntry()
                } label: {
                    Label("Export as TXT", systemImage: "square.and.arrow.up")
                }
            }
            .padding()
        }
        .navigationTitle("Entry Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Share") {
                    exportEntry()
                    showShare = true
                }
            }
        }
        .alert("Delete Entry?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                entry.safeDelete(context: context)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showShare) {
            if let url = exportedURL {
                ShareSheet(activityItems: [url])
            }
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline)
            Text(value).foregroundColor(.secondary)
        }
    }

    private func exportEntry() {
        do {
            exportedURL = try FileExportManager.shared.export(entry: entry)
            showShare = exportedURL != nil
        } catch {
            print("❌ Export failed: \(error)")
            showShare = false
        }
    }
}
