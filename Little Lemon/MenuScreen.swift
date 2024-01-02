//
//  MenuScreen.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI

struct MenuScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Little Lemon").font(.title)
            Text("Nashik").font(.subheadline)
            Text("About the restaurant").font(.caption).foregroundStyle(.primary.opacity(0.8))
            
            List {
                
            }
        }.padding()
    }
}

#Preview {
    MenuScreen()
}
