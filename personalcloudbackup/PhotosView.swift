//
//  PhotosView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 03/10/25.
//

import SwiftUI
import SwiftData

struct PhotosView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NavigationStack{
        PhotosView()
            .modelContainer(for: [ApiDetails.self,UserDetails.self], inMemory: true)
    }
}
