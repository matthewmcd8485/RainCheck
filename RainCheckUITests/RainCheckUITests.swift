//
//  RainCheckUITests.swift
//  RainCheckUITests
//
//  Created by Matt McDonnell on 1/17/25.
//

import XCTest

final class RainCheckUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Set up before each test method in the class.
        continueAfterFailure = false
        
        // Launch the application before running each test.
        XCUIApplication().launch()
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test method in the class.
    }
    
    @MainActor
    func testSearchCityAndDisplayWeather() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the search bar and type a city name
        let searchField = app.textFields["Search Location"]
        XCTAssertTrue(searchField.exists, "Search bar should be visible.")
        searchField.tap()
        searchField.typeText("Chicago")
        
        // Tap the search button
        let searchButton = app.buttons["magnifyingglass"]
        XCTAssertTrue(searchButton.exists, "Search button should be visible.")
        searchButton.tap()
        
        // Verify that the city appears in the search results
        let cityName = app.staticTexts["Chicago"]
        XCTAssertTrue(cityName.waitForExistence(timeout: 5), "City name should appear in the search results.")
        
        // Tap the city in the search results
        cityName.tap()
    }
    
    @MainActor
    func testSavedCityPersistence() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the search bar and type a city name
        let searchField = app.textFields["Search Location"]
        searchField.tap()
        searchField.typeText("New York")
        
        // Tap the search button
        let searchButton = app.buttons["magnifyingglass"]
        searchButton.tap()
        
        // Tap the city in the search results
        let cityName = app.staticTexts["New York"]
        XCTAssertTrue(cityName.waitForExistence(timeout: 5), "City name should appear in the search results.")
        cityName.tap()
        
        // Close and relaunch the app to test persistence
        app.terminate()
        app.launch()
        
        // Verify that the saved city is still displayed
        let savedCityLabel = app.staticTexts["Selected City:"]
        XCTAssertTrue(savedCityLabel.exists, "Saved city view should persist between app launches.")
        let cityNameLabel = app.staticTexts["New York"]
        XCTAssertTrue(cityNameLabel.exists, "Saved city name should persist between app launches.")
    }
    
    @MainActor
    func testClearSearchField() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the search bar and type a city name
        let searchField = app.textFields["Search Location"]
        searchField.tap()
        searchField.typeText("Los Angeles")
        
        // Tap the clear button
        let clearButton = app.buttons["xmark.circle.fill"]
        XCTAssertTrue(clearButton.exists, "Clear button should be visible.")
        clearButton.tap()
        
        // Verify that the search field is empty (equal to placeholder text)
        XCTAssertEqual(searchField.value as? String, "Search Location", "Search field should be cleared.")
    }
}
