//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI

struct Onboarding: View {
    @State var pageIndex = 0
    private let dotAppearance = UIPageControl.appearance()
   
    var body: some View {
        NavigationView {
            TabView(selection: $pageIndex) {
                OnboardView(
                    systemImageName: "hand.wave",
                    title: "Hi Foodie!",
                    description: "Welcome to the LittleLemon Restaurant!",
                    onNext: { withAnimation { pageIndex += 1 } }
                )
                .tag(0)
                
                OnboardView(
                    systemImageName: "fork.knife.circle",
                    title: "Order Anything!",
                    description: "Log In to Dive Deeper: Filter by Category and Order Your Way to Flavor Town!",
                    onNext: { withAnimation { pageIndex += 1 } }
                )
                .tag(1)
                LoginView()
                .tag(2)
            }
            .animation(.easeInOut, value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

#Preview {
    Onboarding()
}
