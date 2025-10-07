//
//  personalcloudbackupApp.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 24/09/25.
//

import SwiftUI
import SwiftData

@main
struct personalcloudbackupApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ApiDetails.self,
            UserDetails.self,
            UploadedPhotos.self
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
            NavigationStack{
                HomeView()
            }            
        }
        .modelContainer(sharedModelContainer)
    }
}
