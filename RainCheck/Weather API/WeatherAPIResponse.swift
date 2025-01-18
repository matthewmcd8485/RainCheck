//
//  WeatherAPIResponse.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import Foundation

struct APIResponse: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
}

struct Current: Codable {
    let temp_f: Double
    let condition: Condition
    let humidity: Double
    let uv: Double
    let feelslike_f: Double
}

struct Condition: Codable {
    let icon: String
}
