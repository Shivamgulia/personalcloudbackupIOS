//
//  TestView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 01/10/25.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Environment(\.modelContext) private var context
    
    @Query var apiDetails: [ApiDetails] 
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TestView()
        .modelContainer(for: ApiDetails.self, inMemory: true)
}
