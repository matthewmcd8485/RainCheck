//
//  City.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import Foundation
import SwiftData

@Model
final class City: Identifiable {
    /// A unique identifier for the `City`.
    var id = UUID()
    
    /// The town's name.
    var name: String
    
    /// The current temperature, displayed in Farenheit.
    var temperature: Int?
    
    /// The current weather condition icon URL
    var conditionIconURL: String?
    
    /// The current whole-number percent humidity
    var humidity: Int?
    
    /// The current UV index.
    var uvIndex: Int?
    
    /// Feels like temperature, displayed in Farenheit.
    var feelsLike: Int?
    
    /// Default initalizer only needs a name.
    ///
    /// All other data fields are loaded later.
    init(name: String) {
        self.name = name
    }
}
