//
//  Little_LemonApp.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI

@main
struct Little_LemonApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isSignedIn {
                Home()
                    .environmentObject(authViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                Onboarding()
                    .environmentObject(authViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
