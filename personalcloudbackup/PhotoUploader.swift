import SwiftUI
import Photos
import SwiftData

class PhotoUploader {
    
    private var apiService = ApiService()

    
    
//    TODO Change this function to check for new photos and only upload new ones
    // Upload all photos
    func uploadAllPhotos(device: String, token: String, photos: [UploadedPhotos], apiUrl : String) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                allPhotos.enumerateObjects { asset, index, _ in
                    if let fileName = self.getFileName(for: asset) {
                        print("File : \(fileName)")
                        if !photos.contains(where: { $0.fileName == fileName }) {
//                            self.requestImageData(for: asset) { data in
//                                if let data = data {
//                                    self.uploadPhoto(
//                                        data: data,
//                                        device: device,
//                                        token: token,
//                                        fileName: fileName,
//                                        apiUrl : apiUrl
//                                    )
//                                } else {
//                                    print("❌ Failed to get image data for asset \(index + 1)")
//                                }
//                            }
                            print("File : \(fileName)")
                        }
                    }
                }
            } else {
                print("❌ Photo access not granted")
            }
        }
    }
    
    private func getFileName(for asset: PHAsset) -> String? {
            let resources = PHAssetResource.assetResources(for: asset)
            return resources.first?.originalFilename
        }
    
    // Get UIImage data from PHAsset
    private func requestImageData(for asset: PHAsset, completion: @escaping (Data?) -> Void) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        
        manager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
            completion(data)
        }
    }
    
    // Upload single photo
    private func uploadPhoto(data: Data, device: String, token: String, fileName: String, apiUrl: String) {
            guard let url = URL(string: "\(apiUrl)/api/v1/s3/upload") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            
            // Add device
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"device\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(device)\r\n".data(using: .utf8)!)
            
            // Add file
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
            
            // End boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            URLSession.shared.uploadTask(with: request, from: body) { responseData, response, error in
                if let error = error {
                    print("❌ Upload failed for \(fileName):", error.localizedDescription)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...201).contains(httpResponse.statusCode) {
                        print("✅ Uploaded \(fileName) successfully (\(httpResponse.statusCode))")
                    } else {
                        print("❌ Upload failed for \(fileName) with status \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        }
    
    
    func updatePhotosListFromApi(device: String, apiUrl : String, token : String) -> [[String : Any]] {
        var page : Int = 0
        var morePages : Bool = true
        
        var photos : [[String : Any]] = []
        
            apiService.getRequest(urlString: "\(apiUrl)/api/v1/photos?device=\(device)&page=\(page)", token : token, completion: { [self]
                result in
                switch result {
                    
                case .failure(let error):
                    print("Error : \(error.localizedDescription)")
                    morePages = false
                    return
                    
                    
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        if let arr = apiService.convertJSONStringToArray(jsonString) {
                            if arr.count < 1 {
                                morePages = false
                                return
                            }
                            photos += arr
                            
                        }
                        else {
                            morePages = false
                        }
                        
                    }
                    else {
                        morePages = false
                    }
                }
            }
            )

        return photos
        
        
        
    }
    
}
