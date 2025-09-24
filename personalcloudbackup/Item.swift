//
//  Item.swift
//  personalcloudbackup
//
//  Created by Shivam Gulia on 24/09/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
