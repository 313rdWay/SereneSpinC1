//
//  SharedData.swift
//  SereneSpin
//
//  Created by Davaughn Williams on 10/12/24.
//

import SwiftUI

class WheelOptions: ObservableObject {
    @Published var options1: [String] = [
        "Meditation",
        "Nature Walk",
        "Creative Time",
        "Listen to Music",
        "Play a Game",
        "Yoga",
        "Walk the Cat",
        "Movie"
    ]
}


class WheelOptions2: ObservableObject {
    @Published var options2: [String] = [
        "Going to the Park",
        "Bike Ride",
        "Call a Friend",
        "Listen to a Podcast",
        "Play a Sport",
        "Workout",
        "Walk the Dog",
        "TV Show",
        "App Design"
    ]
}


func saveItems() {
    
}


