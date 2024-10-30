//
//  Image_steganography_by_sofiaeApp.swift
//  Image_steganography_by_sofiae
//
//  Created by Sofia Elouazzani on 2024-10-14.
//

import SwiftUI
import SwiftData

struct Image_steganography_by_sofiaeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
        .modelContainer(sharedModelContainer)
    }
}
