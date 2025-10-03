//
//  MainView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 02/10/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var userDetails : [UserDetails]
    
    
    var body: some View {
        if userDetails.count < 1 {
            NavigationLink(destination: HomeView()) {
                Text("Please Login")
            }
        }
        else {
            VStack{
                Text("The APi is configured and you have arrived at the home page")
                Text("User Data \(userDetails[0].username)")
                Button (action : {
                    if userDetails.count > 0 {
                        modelContext.delete(userDetails[0])
                        modelContext.hasChanges ? try? modelContext.save() : print("No changes")
                    }
                }) {
                    Text("Delete User Data")
                }
                
                NavigationLink(destination: PhotosView()) {
                    Text("Photo")
                        .font(.largeTitle)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .modelContainer(for: [ApiDetails.self,UserDetails.self], inMemory: true)
    }
}
