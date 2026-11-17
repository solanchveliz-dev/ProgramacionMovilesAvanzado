//
//  Item.swift
//  Compras
//
//  Created by Naomi Solanch Veliz Pie on 17/11/26.
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
