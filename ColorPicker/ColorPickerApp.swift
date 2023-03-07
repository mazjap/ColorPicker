//
//  ColorPickerApp.swift
//  ColorPicker
//
//  Created by Jordan Christensen on 3/7/23.
//

import SwiftUI

@main
struct ColorPickerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
