//
//  LoginView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 01/10/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var apiDetails: [ApiDetails]
    @Query private var userDetails : [UserDetails]
    
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    
    let apiService = ApiService()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
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
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: loginUser) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear(perform: {
            if userDetails.count > 0 {
                dismiss()
            }
        })
    }
    
    
    private func loginUser() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }
        
        // TODO: Call your API here
        let postBody: [String: Any] = ["username": username, "password": password]
        if apiDetails.count < 1{
            errorMessage = "No Api url configured"
            return
        }
        
        print("\(postBody)")
        print("Logging in with \(username), \(password)")
        
        apiService.postRequest(urlString: "\(apiDetails[0].url)/api/auth/login", body: postBody, token : "") { result in
            switch result {
                
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    return
                    
                    
                case .success(let data):
                    print("POST Response:", String(data: data, encoding: .utf8) ?? "")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        if let dict = apiService.convertJSONStringToDictionary(jsonString) {
                            var token : String = ""
                            var authorities : [String] = []
                            if dict["token"] != nil {
                                print("token : \(dict["token"], default: "invalid string")")
                                token = dict["token"] as! String
                                if type(of: dict["token"]) == String.self {
                                    print("in token")
                                    token = dict["token"] as! String
                                }
                            }
                            else {
                                errorMessage = "Login Failed"
                                return
                            }
                            
                            
                            if dict["authorities"] != nil {
                                print("authorities  : \(dict["authorities"] as! [String])")
                                authorities = dict["authorities"] as! [String]
                                if type(of: dict["authorities"]) == [String].self {
                                    print("in authorities")
                                    authorities = dict["authorities"] as! [String]
                                }
                            }
                            else {
                                errorMessage = "Login Failed"
                                return
                            }
                            
                            modelContext.insert(UserDetails(username: username, token: token, authorities: authorities))
                            modelContext.hasChanges ? try? modelContext.save() : print("No changes")
                            dismiss()
                            
                            
                        }
                    }
                
            }
        }
    
        print("Loged in with \(username), \(password)")
    }

}

#Preview {
    LoginView()
        .modelContainer(for: [ApiDetails.self,UserDetails.self], inMemory: true)
}
