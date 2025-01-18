//
//  HomeView.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import SwiftUI
import SwiftData

/// The main view of the RainCheck app, allowing users to search for, select, and display weather information for cities.
///
/// The `HomeView` provides the following functionalities:
/// - A search bar to look up weather information for cities.
/// - Display of search results with options to select and save a city.
/// - Display of weather details for a saved city.
/// - Error handling and feedback when fetching weather data fails.
///
/// This view interacts with a `ModelContainer` to manage the persisted/saved city and leverages async/await for network requests.
struct HomeView: View {
    /// The environment's model context used for managing persistent data.
    @Environment(\.modelContext) private var modelContext
    
    /// The list of saved cities stored in the `modelContext`.
    @Query private var savedCities: [City]
    
    /// The first saved city from the `savedCities` list, if available.
    private var savedCity: City? {
        savedCities.first
    }
    
    /// The text entered into the search bar.
    @State private var searchText = ""
    
    /// The list of search results returned from the ``WeatherAPI``.
    @State private var searchResults: [City] = []
    
    /// An error message to display if fetching weather data fails.
    @State private var errorMessage: String?
    
    /// A flag to hide the saved ``CityView`` while searching for a new ``City``.
    @State private var hideSavedCityView = false
    
    /// The body of the view.
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Tap gesture to dismiss the keyboard.
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissKeyboard()
                    }
                
                VStack {
                    searchBarView
                        .padding()
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding()
                    } else if !searchResults.isEmpty {
                        ForEach(searchResults) { city in
                            Button(action: {
                                saveCity(city)
                                searchText = ""
                                searchResults = []
                                hideSavedCityView = false
                            }) {
                                SearchResultListItemView(city: city)
                                    .padding(.horizontal)
                            }
                            .tint(Color(UIColor.label))
                        }
                    }
                    
                    Spacer()
                    
                    // Display the saved city if it exists.
                    if let savedCity = savedCity, !hideSavedCityView {
                        VStack {
                            Text("Selected City:")
                                .font(.headline)
                            CityView(city: savedCity)
                                .padding()
                        }
                    } else if searchText == "" {
                        placeholderView
                    }
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            if let city = savedCity {
                Task {
                    await fetchWeather(for: city.name)
                }
            }
        }
    }
    
    // MARK: - Search Bar
    /// A search bar view for entering and submitting ``City`` names.
    var searchBarView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack {
                TextField("Search Location", text: $searchText)
                    .font(.custom("Poppins-Regular", size: 16))
                    .submitLabel(.search)
                    .onSubmit {
                        if searchText.count > 2 {
                            Task {
                                await searchCities(query: searchText)
                                hideSavedCityView = true
                            }
                        }
                    }
                    .padding(.horizontal)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        errorMessage = nil
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .symbolRenderingMode(.hierarchical)
                            .padding(.trailing)
                    }
                }
                
                Button(action: {
                    if searchText.count > 2 {
                        Task {
                            await searchCities(query: searchText)
                            hideSavedCityView = true
                        }
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                }
                .padding(.trailing)
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // MARK: - Placeholder View
    /// A placeholder view displayed when no ``City`` is selected and no search is in progress.
    var placeholderView: some View {
        VStack {
            Text("No City Selected")
                .font(.custom("Poppins-Bold", size: 30))
            
            Text("Please Search for a City")
                .font(.custom("Poppins-Regular", size: 20))
        }
    }
    
    // MARK: - Fetching Weather Data
    /// Fetches weather data for the specified ``City`` and updates the saved city.
    ///
    /// - Parameter cityName: The name of the city for which to fetch weather data.
    private func fetchWeather(for cityName: String) async {
        errorMessage = nil
        do {
            let city = try await WeatherAPI().fetchWeather(for: cityName)
            saveCity(city)
        } catch {
            errorMessage = "Failed to fetch weather:\n\n \(error.localizedDescription)"
        }
    }
    
    // MARK: - Search Cities
    /// Searches for cities matching the given query.
    ///
    /// - Parameter query: The city name or partial name to search for.
    private func searchCities(query: String) async {
        errorMessage = nil
        do {
            let city = try await WeatherAPI().fetchWeather(for: query)
            searchResults = [city]
        } catch {
            errorMessage = "Failed to fetch weather:\n\n \(error.localizedDescription)\n\n(Are you sure this city exists?)"
            searchResults = []
        }
    }
    
    // MARK: - Save City
    /// Saves a ``City`` to the `modelContext`, replacing any previously saved city.
    ///
    /// - Parameter city: The ``City`` object to save.
    private func saveCity(_ city: City) {
        do {
            for existingCity in savedCities {
                modelContext.delete(existingCity)
            }
            
            modelContext.insert(city)
            
            try modelContext.save()
            
        } catch {
            errorMessage = "Failed to save city: \(error.localizedDescription)"
        }
    }
    
    /// Dismisses the keyboard if it is currently active.
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    HomeView()
        .modelContainer(for: City.self, inMemory: true)
}
