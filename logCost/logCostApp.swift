//
//  logCostApp.swift
//  logCost
//
//  Created by McLin on 2025/7/18.
//

import SwiftUI
import SwiftData

@main
struct logCostApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Transitions.self)
        .environmentObject(UserSettings())
        .environmentObject(SystemSettings())
    }
}
