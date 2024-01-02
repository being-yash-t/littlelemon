//
//  AuthViewModel.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool
    
    init() {
        isSignedIn = UserDefaults.standard.string(forKey: UserDefaultsKey.email.rawValue) != nil
    }
    
    func signIn(firstName: String, lastName: String, email: String) {
        UserDefaults.standard.set(firstName, forKey: UserDefaultsKey.firstName.rawValue)
        UserDefaults.standard.set(lastName, forKey: UserDefaultsKey.lastName.rawValue)
        UserDefaults.standard.set(email, forKey: UserDefaultsKey.email.rawValue)
        isSignedIn = true
    }
        
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.firstName.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.lastName.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.email.rawValue)
        isSignedIn = false
    }
}
