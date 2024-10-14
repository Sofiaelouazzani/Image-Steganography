//
//  Item.swift
//  Image_steganography_by_sofiae
//
//  Created by Sofia Elouazzani on 2024-10-14.
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