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
    
    @Query private var userDetails :[UserDetails]
    @Query private var apiDetails : [ApiDetails]
    
    private var photoUploadService = PhotoUploader()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(perform: {
//                photoUploadService.uploadAllPhotos(device: "shivam's Iphone", token: "Bearer \(userDetails[0].token)")
                photoUploadService.updatePhotosListFromApi(device: "shivam's Iphone", apiUrl : apiDetails[0].url , token : userDetails[0].token)
            })
    }
}

#Preview {
    NavigationStack{
        PhotosView()
            .modelContainer(for: [ApiDetails.self, UserDetails.self, UploadedPhotos.self], inMemory: true)
    }
}
