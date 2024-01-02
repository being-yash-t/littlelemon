//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI

struct UserProfile: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var firstName: String? = nil
    @State var lastName: String? = nil
    @State var email: String? = nil
    
    init() {
        loadData()
    }
    
    func loadData() {
        firstName = UserDefaults.standard.string(forKey: UserDefaultsKey.firstName.rawValue)
        lastName = UserDefaults.standard.string(forKey: UserDefaultsKey.lastName.rawValue)
        email = UserDefaults.standard.string(forKey: UserDefaultsKey.email.rawValue)
    }
    var body: some View {
        VStack {
            Spacer()
            if firstName != nil && lastName != nil && email != nil {
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .clipShape(.circle)
                .frame(width: 100, height: 100)
                .overlay(RoundedRectangle(cornerRadius: 100).stroke(.gray, lineWidth: 2))
            
                Text("\(firstName!) \(lastName!)")
                Text(email!)
            } else {
                Text("No User :(")
            }
            Spacer()
            if email != nil {
                Button("Logout") {
                    authViewModel.signOut()
                    dismiss()
                }
            }
        }
        .onAppear { loadData() }
        .navigationTitle("Personal Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        UserProfile()
    }
}
