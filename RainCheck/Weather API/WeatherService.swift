//
//  WeatherService.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import Foundation

protocol WeatherService {
    func fetchWeather(for cityName: String) async throws -> City
}
