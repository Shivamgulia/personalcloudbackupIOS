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
