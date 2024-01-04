//
//  Home.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            TabView {
                MenuScreen().tabItem { Label("Menu", systemImage: "list.dash") }
                UserProfile().tabItem { Label("Profile", systemImage: "square.and.pencil") }
            }.tint(.yellow)
        }
    }
}

#Preview {
    Home()
}
