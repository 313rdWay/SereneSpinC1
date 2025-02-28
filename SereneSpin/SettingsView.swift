//
//  SettingsView.swift
//  SereneSpin
//
//  Created by Davaughn Williams on 10/10/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var wheelOptions: WheelOptions  // Accept the shared data model
    @ObservedObject var wheelOptions2: WheelOptions2

    @State private var optionsToAdd = ""
    @State private var selectedWheel = 1 // Track which wheel to add options to

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Wheel #1")) {
                        ForEach(wheelOptions.options1, id: \.self) { option in
                            Text(option)
                        }
                        .onMove(perform: moveOptions1)
                        .onDelete(perform: deleteOptions1)
                    }
                    
                    Section(header: Text("Wheel #2")) {
                        ForEach(wheelOptions2.options2, id: \.self) { option in
                            Text(option)
                        }
                        .onMove(perform: moveOptions2)
                        .onDelete(perform: deleteOptions2)
                    }
                }
                .navigationTitle("Settings")
                .listStyle(.grouped)
                .navigationBarItems(trailing: EditButton())
                
                Picker("Select Wheel", selection: $selectedWheel) {
                    Text("Wheel #1").tag(1)
                    Text("Wheel #2").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                HStack {
                    TextField("Add Option", text: $optionsToAdd)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            addOption()
                        }
                    
                    Button("Add") {
                        addOption()
                    }
                    .buttonStyle(.borderedProminent)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 50)
                    .cornerRadius(90)
                }
                .padding()
            }
        }
    }

    func addOption() {
        guard !optionsToAdd.isEmpty else { return }
        
        if selectedWheel == 1 {
            wheelOptions.options1.append(optionsToAdd)
        } else {
            wheelOptions2.options2.append(optionsToAdd)
        }
        optionsToAdd = "" // Clear the text field after adding
    }

    func moveOptions1(from source: IndexSet, to destination: Int) {
        wheelOptions.options1.move(fromOffsets: source, toOffset: destination)
    }
    
    func moveOptions2(from source: IndexSet, to destination: Int) {
        wheelOptions2.options2.move(fromOffsets: source, toOffset: destination)
    }

    func deleteOptions1(at offsets: IndexSet) {
        wheelOptions.options1.remove(atOffsets: offsets)
    }
    
    func deleteOptions2(at offsets: IndexSet) {
        wheelOptions2.options2.remove(atOffsets: offsets)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(wheelOptions: WheelOptions(), wheelOptions2: WheelOptions2())
    }
}
