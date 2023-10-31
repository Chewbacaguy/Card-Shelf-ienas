//
//  BookWormApp.swift
//  BookWorm
//
//  Created by Santiago Torres Alvarez on 26/10/23.
//

import SwiftUI

@main
struct BookWormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
