//
//  ContentView.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 24/09/25.
//

import SwiftUI
import SwiftData
import Photos



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    func requestPhotoLibraryAccess() {
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized, .limited:
                    print("Access granted")
                    self.fetchAllPhotosAsImages()
                case .denied, .restricted, .notDetermined:
                    print("Access denied")
                @unknown default:
                    break
                }
            }
        }
    
    func fetchAllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        allPhotos.enumerateObjects { (asset, _, _) in
            print("Photo asset: \(asset)")
        }
    }

        
        // Fetch all photos as assets and then images
    private func fetchAllPhotosAsImages() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let imageManager = PHImageManager.default()
        
        allPhotos.enumerateObjects { (asset, _, _) in
            let targetSize = CGSize(width: 300, height: 300) // thumbnail size
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            
            imageManager.requestImage(for: asset,
                                      targetSize: targetSize,
                                      contentMode: .aspectFill,
                                      options: options) { image, _ in
                if let img = image {
                    let pngData = img.pngData()
                    let CGpoint = CGPoint(x: 10, y: 10)
                    img.draw(at: CGpoint)
                    print("📷 Got photo: \(String(describing: pngData))")
                    // 👉 You can collect these images in an array or show them in a UICollectionView
                }
            }
        }
    }
    
    

            
    
    var body : some View{
        VStack {
            Text("Photos")
            
            Button("Request Access", action: requestPhotoLibraryAccess)
            
            Button("Log Photos", action: fetchAllPhotos)
            
            Button("Log Full Photos", action: fetchAllPhotosAsImages)
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: ApiDetails.self, inMemory: true)
}
