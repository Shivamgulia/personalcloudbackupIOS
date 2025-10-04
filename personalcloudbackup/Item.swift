//
//  Item.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 24/09/25.
//

import Foundation
import SwiftData

@Model
final class ApiDetails: Identifiable {
    
    var url:String
    
    init(url: String) {
        self.url = url
    }
    
}


@Model
final class UserDetails : Identifiable {
    var username: String
    var token: String
    var authorities : [String]
    
    
    init(username: String, token: String, authorities : [String]) {
        self.username = username
        self.token = token
        self.authorities = authorities
    }
    
    
}


@Model
final class UploadedPhotos : Identifiable {
    var fileName : String
    var id : String
    var device : String
    var user : String
    var s3Key : String
    var createdAt : String
    var uploadedAt : String
    var size : Int
    var contentType : String
    
    init(fileName: String, id: String, device: String, user: String, s3Key: String, createdAt: String, uploadedAt: String, size: Int, contentType: String) {
        self.fileName = fileName
        self.id = id
        self.device = device
        self.user = user
        self.s3Key = s3Key
        self.createdAt = createdAt
        self.uploadedAt = uploadedAt
        self.size = size
        self.contentType = contentType
    }
}
