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
    @Query private var uploadedPhotos : [UploadedPhotos]
    
    private var photoUploadService = PhotoUploader()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(perform: uploadPhotos)
    }
    
    func uploadPhotos() {
        print("upload process started")
        photoUploadService.updatePhotosListFromApi(device: "shivam's Iphone", apiUrl : apiDetails[0].url , token : userDetails[0].token, completion: {
            result in
            switch result {
                
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
                return
                
                
            case .success(let photos):
                if photos != nil {
                    if photos.count > 0 {
                        
                        for photo in uploadedPhotos {
                            modelContext.delete(photo)
                        }
                        
                        modelContext.hasChanges ? try? modelContext.save() : print("No changes")
                        
                        for index in 0...photos.count-1 {
                            print("adding Photo \(photos[index]["fileName"] as! String)")
                            modelContext.insert(UploadedPhotos(fileName: photos[index]["fileName"] as! String, id: photos[index]["id"] as! String, device: photos[index]["device"] as! String, user: photos[index]["user"] as! String, s3Key: photos[index]["s3Key"] as! String, createdAt: photos[index]["createdAt"] as! String, uploadedAt: photos[index]["uploadedAt"] as! String, size: photos[index]["size"] as! Int, contentType: photos[index]["contentType"] as! String))
                            
                        }
                        
                        modelContext.hasChanges ? try? modelContext.save() : print("No changes")
                    }
                    
                    print(uploadedPhotos)
                    print("uploading all new photos")
                    print(photos.count)
                    
                    photoUploadService.uploadAllPhotos(device: "shivam's Iphone", token: userDetails[0].token, photos: uploadedPhotos, apiUrl: apiDetails[0].url)
                    
                    print("uploading success")
                }
            }
        }
        )
    }
}

#Preview {
    NavigationStack{
        PhotosView()
            .modelContainer(for: [ApiDetails.self, UserDetails.self, UploadedPhotos.self], inMemory: true)
    }
}
