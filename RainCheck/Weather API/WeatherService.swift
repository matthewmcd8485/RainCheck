//
//  WeatherService.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import Foundation

/// A protocol defining the requirements for a weather service.
///
/// Types conforming to this protocol must provide functionality to fetch weather information for a given city.
protocol WeatherService {
    /// Fetches weather data for a specified city.
    ///
    /// This asynchronous method retrieves weather data for the specified city name. The implementation is expected to handle networking and data decoding.
    ///
    /// - Parameter cityName: The name of the city for which to fetch weather data.
    /// - Returns: A ``City`` object containing weather information for the specified city.
    /// - Throws: An error if the network request or data decoding fails.
    func fetchWeather(for cityName: String) async throws -> City
}
