//
//  HomeView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 01/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var apiDetails: [ApiDetails]
    @Query private var userDetails : [UserDetails]
    
    @State var showApiForm: Bool = false
    @State var showLoginForm : Bool = false
    @State var showregisterForm : Bool = false
    
    
    var body: some View {
        VStack{
            
            if userDetails.count < 1 {
                VStack {
                    Button(action : {
                        showLoginForm = !showLoginForm
                    }) {
                        Text("Login")
                    }
                    Button(action : {
                        showregisterForm = !showregisterForm
                    }) {
                        Text("Register")
                    }
                    Button(action : {
                        if apiDetails.count > 0 {
                            modelContext.delete(apiDetails[0])
                            modelContext.hasChanges ? try? modelContext.save() : print("No changes")
                        }
                    }) {
                        Text("Clear API URL")
                    }
                    Button (action : {
                        if userDetails.count > 0 {
                            modelContext.delete(userDetails[0])
                            modelContext.hasChanges ? try? modelContext.save() : print("No changes")
                        }
                    }) {
                        Text("Delete User Data")
                    }
                }
            }
            else {
                MainView()
            }
        }.sheet(isPresented: $showApiForm, content: {
            AddApiDetailsView()
        })
        .sheet(isPresented: $showLoginForm, content: {
            LoginView()
        })
        .sheet(isPresented: $showregisterForm, content: {
            RegisterView()
        }).onAppear(perform: checkIfApiFormNeeded).navigationTitle("Home")
        
    }
    
    func checkIfApiFormNeeded() {
        print(apiDetails)
        if apiDetails.count < 1 {
                showApiForm = true
        }
    }
    
}

#Preview {
    NavigationStack{
        HomeView()
            .modelContainer(for: [ApiDetails.self, UserDetails.self], inMemory: true)
    }
}
