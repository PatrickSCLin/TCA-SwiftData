//
//  Item.swift
//  TCA-SwiftData
//
//  Created by Patrick Lin on 2024/6/13.
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
