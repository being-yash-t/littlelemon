//
//  OnboardView.swift
//  Little Lemon
//
//  Created by Jay Thakur on 04/01/24.
//

import SwiftUI

struct OnboardView: View {
    let systemImageName: String
    let title: String
    let description: String
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.yellow)
            
            Text (title)
                .font(.title).bold()
            Text (description)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Spacer()
            Button("Next") { onNext() }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    OnboardView(systemImageName: "map", title: "Hello", description: "Lourem ipsum", onNext: {})
}
