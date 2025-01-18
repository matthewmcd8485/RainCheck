//
//  WeatherAPI.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import Foundation

/// A service class responsible for fetching weather data from the weatherAPI.com service.
///
/// This class conforms to the ``WeatherService`` protocol and provides functionality to retrieve weather information for a specified city using the `WeatherAPI`.
class WeatherAPI: WeatherService {
    /// The API key used to authenticate with the WeatherAPI.
    ///
    /// This value is stored in an ignored file for security purposes.
    private let apiKey = APIKey.weatherAPIKey
    
    /// Fetches weather data for a specified city.
    ///
    /// This asynchronous method retrieves current weather information for the given city name by making a network request to the WeatherAPI. The response is decoded into a ``City`` object.
    ///
    /// - Parameter cityName: The name of the city for which to fetch weather data.
    /// - Returns: A ``City`` object populated with current weather information for the specified location.
    /// - Throws: A `URLError` if the URL is invalid, or any error thrown during the network request or JSON decoding process.
    /// - Note: Ensure you have a valid `weatherAPIKey` set in the hidden ``APIKey`` class.
    func fetchWeather(for cityName: String) async throws -> City {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityName)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weatherResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        // Populate and return the City object
        let weather = weatherResponse.current
        let city = City(name: weatherResponse.location.name)
        city.temperature = Int(weather.temp_f.rounded())
        city.conditionIconURL = weather.condition.icon
        city.humidity = Int(weather.humidity)
        city.uvIndex = Int(weather.uv.rounded())
        city.feelsLike = Int(weather.feelslike_f.rounded())
        
        return city
    }
}
