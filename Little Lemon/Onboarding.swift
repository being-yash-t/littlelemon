//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI

struct Onboarding: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    
    @State var errorMessage: String? = nil
    
    var dataIsValid: Bool {
        if firstName.isEmpty {
            errorMessage = "First name cannot be empty"
        } else if lastName.isEmpty {
            errorMessage = "Last name cannot be empty"
        } else if !isValidEmail() {
            errorMessage = "Email is invalid"
        } else {
            errorMessage = nil
            return true
        }
        
        return false
    }
   
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                TextField("First Name", text: $firstName)
                    .onChange(of: firstName) { let _ = dataIsValid }
                TextField("Last Name", text: $lastName)
                    .onChange(of: lastName) { let _ = dataIsValid }
                TextField("Email", text: $email)
                    .onChange(of: email) { let _ = dataIsValid }
                
                if errorMessage != nil {
                    Text(errorMessage!).foregroundColor(.red)
                }
                
                Button("Register") {
                    if dataIsValid {
                        authViewModel.signIn(firstName: firstName, lastName: lastName, email: email)
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .navigationTitle("Login")
        }
    }
    
    func isValidEmail() -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
      return predicate.evaluate(with: email)
    }
}

#Preview {
    Onboarding()
}
