//
//  Item.swift
//  Image steganography
//
//  Created by Sofia Elouazzani on 2024-10-13.
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
