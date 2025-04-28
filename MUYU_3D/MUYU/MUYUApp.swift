//
//  MUYUApp.swift
//  MUYU
//
//  Created by Sophie on 26/4/2025.
//

import SwiftUI

@main
struct MUYUApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
