//
//  City.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class City {
    var name: String
    
    var temperature: Int?
    
    var condition: String?
    
    var humidity: Double?
    
    var uvIndex: Int?
    
    var feelsLike: Int?
    
    init(name: String) {
        self.name = name
    }
}
