//
//  HomeView.swift
//  SereneSpin
//
//  Created by Davaughn Williams on 10/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var wheelOptions = WheelOptions()  // Create the shared data model
    @StateObject private var wheelOptions2 = WheelOptions2()
    @State private var isSpinning = false
    @State private var selectedValue: String?  // Keep this as an optional
    @State private var rotationAngle = 0.0
    @State private var displaySereneSpin = true  // State variable to control the display of "Serene Spin"

    let colors: [Color] = [.wheelRed, .wheelBlue, .wheelPink, .wheelGreen, .wheelOrange, .wheelPurple, .wheelYellow, .wheelLightBlue]
    let count = 8  // Number of slices

    var body: some View {
        NavigationStack {
            ZStack {
                Color("OffWhiteBG")
                    .ignoresSafeArea()

                VStack {
                    NavigationLink(destination: SettingsView(wheelOptions: wheelOptions, wheelOptions2: wheelOptions2)) {
                        Image(systemName: "gearshape")
                            .font(.largeTitle)
                            .foregroundColor(.buttonPurple)
                            .padding(.leading, 300)
                    }

                    // Safely unwrap the selected value and show colorful letters
                    if let selectedValue = selectedValue, !selectedValue.isEmpty {
                        HStack(spacing: 0) {
                            // Use enumerated to get index and character
                            ForEach(Array(selectedValue.enumerated()), id: \.offset) { index, char in
                                Text(String(char))
                                    .font(.custom("Poppins-Black", size: 60))
                                    .foregroundColor(colors[index % colors.count])  // Cycle through colors
                            }
                        }
                        .padding(.top, 20)
                        .onAppear {
                            // Set a timer to change back to "Serene Spin" after 15 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                                resetDisplay()
                            }
                        }
                    } else {
                        // Display "Serene Spin" if no value is selected
                        if displaySereneSpin {
                            HStack {
                                Text("Serene")
                                    .font(.custom("Poppins-Black", size: 60))
                                    .foregroundColor(.text)
                                Text("Spin!")
                                    .font(.custom("Poppins-MediumItalic", size: 60))
                                    .foregroundColor(.text)
                            }
                        }
                    }
                    Spacer()

                    ZStack {
                        // Loop to create the pie slices
                        ForEach(0..<count, id: \.self) { index in
                            let sliceStartAngle = Double(index) / Double(count) * 360
                            let sliceEndAngle = Double(index + 1) / Double(count) * 360

                            Pie(startAngle: .degrees(sliceStartAngle), endAngle: .degrees(sliceEndAngle))
                                .fill(colors[index])

                            // Calculate the rotation for the text
                           /* let textRotation = sliceStartAngle + (360.0 / Double(count)) / 2 - 90  // Adjust for center alignment

                            // Use the options from WheelOptions with proper alignment
                            Text(wheelOptions.options1[index])
                                .font(.custom("Poppins-Light", size: 20))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(textRotation))
                                .offset(y: -100)  // Adjust the offset for better positioning*/
                        }
                    }
                    .frame(width: 400, height: 400)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(isSpinning ? Animation.linear(duration: 4).repeatCount(1, autoreverses: false) : .default, value: isSpinning)

                    Spacer()

                    Button("SPIN") {
                        startSpinning()  // Start spinning
                    }
                    .buttonStyle(PlainButtonStyle())  // Use PlainButtonStyle for custom styling
                    .frame(width: 350, height: 60)  // Set the size of the button
                    .background(Color.buttonPurple)  // Set the background color
                    .cornerRadius(30)  // Adjust the corner radius for long rounded ends
                    .foregroundColor(.white)  // Set text color to white
                    .font(.custom("Nunito[wght]", size: 50))  // Set the font
                    .padding(.bottom)  // Add bottom padding
                }
            }
        }
    }

    // Function to reset display after 15 seconds
    private func resetDisplay() {
        selectedValue = nil  // Clear the selected value
        displaySereneSpin = true  // Show "Serene Spin" again
    }

    // Spin logic and selecting a slice
    func startSpinning() {
        selectedValue = nil  // Clear previous selection
        isSpinning = true
        displaySereneSpin = false  // Hide "Serene Spin" when spinning starts

        // Create the haptic feedback generator
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()  // Prepare the generator for haptic feedback

        let randomAngle = Double.random(in: 1080...1800)  // Random rotation angle (3 to 5 full spins)

        withAnimation(Animation.linear(duration: 4)) {
            rotationAngle += randomAngle  // Spin the wheel

            // Trigger haptic feedback during the spin
            for i in 0..<5 {  // Adjust the number of feedback triggers as needed
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.8) {
                    feedbackGenerator.impactOccurred()  // Trigger haptic feedback
                }
            }
        }

        // After animation ends, find the selected slice
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isSpinning = false

            // Calculate the final stopping angle
            let normalizedAngle = (rotationAngle.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)

            // Offset by half a slice to ensure the selected slice is correctly chosen
            let sliceAngle = 360.0 / Double(count)  // Each slice angle
            let adjustedAngle = normalizedAngle + sliceAngle / 2

            // Determine the selected slice index
            let selectedIndex = Int(adjustedAngle / sliceAngle) % count
            selectedValue = wheelOptions.options1[selectedIndex]  // Get the label of the selected slice
        }
    }
}

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        return path
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}










