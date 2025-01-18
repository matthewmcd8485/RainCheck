//
//  WeatherAPIResponse.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import Foundation

/// Represents the response from an API call.
struct APIResponse: Codable {
    /// The location details of the API response.
    let location: Location
    
    /// The current weather details of the API response.
    let current: Current
}

/// Represents the details of a specific location.
struct Location: Codable {
    /// The name of the location, e.g., Chicago.
    let name: String
}

/// Represents the current weather data.
struct Current: Codable {
    /// The current temperature in Fahrenheit.
    let temp_f: Double
    
    /// The current weather condition details.
    let condition: Condition
    
    /// The current humidity level as a percentage.
    let humidity: Double
    
    /// The current UV index value.
    let uv: Double
    
    /// The current "feels like" temperature in Fahrenheit.
    let feelslike_f: Double
}

/// Represents a weather condition.
struct Condition: Codable {
    /// The URL path to an icon representing the weather condition.
    let icon: String
}
