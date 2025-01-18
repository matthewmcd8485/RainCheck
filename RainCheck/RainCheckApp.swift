//
//  RainCheckApp.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import SwiftUI
import SwiftData

/// The main entry point for the RainCheck application.
@main
struct RainCheckApp: App {
    /// The shared model container used for managing the app's ``City`` model.
    ///
    /// This will persist saved data between app launches.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            City.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    /// The body of the app, defaulting to ``HomeView`` and loading the `modelContainer`.
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
