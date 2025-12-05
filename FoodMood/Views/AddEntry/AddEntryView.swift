//
//  AddEntryView.swift
//  FoodMood
//
//  Created by Dhruv Rasikbhai Jivani on 12/4/25.
//

import SwiftUI
internal import CoreData

struct AddEntryView: View {

    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm: AddEntryViewModel
    @StateObject private var aiVM = AIRecognitionViewModel()

    @State private var showImagePicker = false
    @State private var showCamera = false

    init() {
        _vm = StateObject(wrappedValue: AddEntryViewModel(
            context: PersistenceController.shared.container.viewContext
        ))
    }

    var body: some View {
        NavigationStack {
            Form {

                Section("Meal Information") {
                    TextField("Meal name", text: $vm.mealName)

                    MoodPicker(selectedMood: $vm.mood)

                    Stepper("Calories: \(vm.calories)", value: $vm.calories, in: 0...5000)

                    TextEditor(text: $vm.notes)
                        .frame(height: 90)
                }

                Section("Photo") {
                    if let img = vm.image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    HStack {
                        Button("Choose Photo") { showImagePicker = true }
                        Spacer()
                        Button("Camera") { showCamera = true }
                    }
                }

                Section("AI Prediction") {
                    if aiVM.isLoading {
                        ProgressView("Identifying food...")
                    } else {
                        Text(aiVM.prediction.isEmpty ? "No prediction yet." : aiVM.prediction)
                            .font(.headline)

                        if !aiVM.prediction.isEmpty {
                            Button("Use Prediction") {
                                vm.aiPrediction = aiVM.prediction
                            }
                        }
                    }

                    if vm.image != nil {
                        Button("Analyze with AI") {
                            Task {
                                if let img = vm.image {
                                    Task {
                                        await aiVM.analyze(image: img)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveEntry() }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $vm.image)
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $vm.image)
            }
            .alert("Validation Error", isPresented: $vm.showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(vm.validationMessage)
            }
        }
    }

    private func saveEntry() {
        vm.saveEntry()
        if !vm.showValidationError {
            dismiss()
        }
    }
}
