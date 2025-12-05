//
//  DailyLogListView.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import Foundation
internal import CoreData
import SwiftUI

struct DailyLogListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: LogEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \LogEntry.date, ascending: false)]
    ) var entries: FetchedResults<LogEntry>
    
    @StateObject private var quoteVM = QuoteViewModel()
    @StateObject private var logVM: LogEntryViewModel

    @State private var showAddView = false
    @State private var showDetail: LogEntry? = nil

    init() {
        let context = PersistenceController.shared.container.viewContext
        _logVM = StateObject(wrappedValue: LogEntryViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // Quote Bar
                quoteSection

                // Entries List
                List {
                    ForEach(entries) { entry in
                        LogRowView(entry: entry)
                            .onTapGesture { showDetail = entry }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
            }
            .navigationTitle("FoodMood Logs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                    }
                }
            }
            .sheet(item: $showDetail) { entry in
                DetailView(entry: entry)
            }
            .sheet(isPresented: $showAddView) {
                AddEntryView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .task {
                await quoteVM.fetchQuote()
            }
        }
    }

    // MARK: - Quote Section
    private var quoteSection: some View {
        VStack(spacing: 4) {
            Text("“\(quoteVM.quoteText)”")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if !quoteVM.author.isEmpty {
                Text("- \(quoteVM.author)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
    }

    // MARK: - Delete Entry
    // MARK: - Delete Entry
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let entry = entries[index]
            // Use non-throwing safeDelete
            entry.safeDelete(context: viewContext)
        }
    }
}
