//
//  RainCheckTests.swift
//  RainCheckTests
//
//  Created by Matt McDonnell on 1/17/25.
//

import Testing
@testable import RainCheck

struct RainCheckTests {

    // Test to fetch weather for a valid city
    @Test
    func testFetchWeatherValidCity() async throws {
        let weatherAPI = WeatherAPI()

        let city = try await weatherAPI.fetchWeather(for: "Chicago")
        
        // Assertions
        #expect(city.name == "Chicago", "Expected city name to be 'Chicago'")
        #expect(city.temperature != nil, "Temperature should not be nil.")
        #expect(city.humidity != nil, "Humidity should not be nil.")
        #expect(city.uvIndex != nil, "UV index should not be nil.")
        #expect(city.feelsLike != nil, "Feels like temperature should not be nil.")
    }
    
    // Test to fetch weather for an invalid city
    @Test
    func testFetchWeatherInvalidCity() async throws {
        let weatherAPI = WeatherAPI()
        
        do {
            _ = try await weatherAPI.fetchWeather(for: "InvalidCityName123")
            #expect(Bool(false), "Expected an error for an invalid city, but no error was thrown.")
        } catch {
            #expect(true, "Error was correctly thrown for an invalid city.")
        }
    }

}
