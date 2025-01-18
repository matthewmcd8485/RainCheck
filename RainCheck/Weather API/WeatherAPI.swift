//
//  WeatherAPI.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import Foundation

class WeatherAPI: WeatherService {
    private let apiKey = APIKey.weatherAPIKey
    
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
