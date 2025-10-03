//
//  RegisterView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 01/10/25.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var apiDetails: [ApiDetails]
    @Query private var userDetails : [UserDetails]
        
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var successMessage : String?
    
    let apiService = ApiService()
        
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $username)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.blue)
                    .font(.caption)
            }
            
            Button(action: registerUser) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func registerUser() {
        guard !username.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        // TODO: Call your API here
        print("Registering with \(username), \(password)")
        
        
        
        if apiDetails.count < 1{
            errorMessage = "No Api url configured"
            return
        }
        
        let postBody: [String: Any] = ["username": username, "password": password]
        
        apiService.postRequest(urlString: "\(apiDetails[0].url)/api/auth/register", body: postBody) { result in
            switch result {
            case .success(let data):
                print("POST Response:", String(data: data, encoding: .utf8) ?? "")
                if let jsonString = String(data: data, encoding: .utf8) {
                    if let dict = apiService.convertJSONStringToDictionary(jsonString) {
                        successMessage = "You Have Success Fully Registered Please get verified by the admin to login and use the app"
                    }
                    else {
                        errorMessage = "Register Failed"
                    }
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
        
        print("Loged in with \(username), \(password)")
    }
        
}

#Preview {
    RegisterView()
        .modelContainer(for: ApiDetails.self, inMemory: true)
}
