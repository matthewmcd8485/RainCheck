//
//  HomeView.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedCities: [City]
    
    private var savedCity: City? {
        savedCities.first
    }
    
    @State private var searchText = ""
    @State private var searchResults: [City] = []
    @State private var errorMessage: String?
    @State private var hideSavedCityView = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                // Tap gesture to dismiss keyboard
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
                    
                    // Display the saved city if it exists
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
    var placeholderView: some View {
        VStack {
            Text("No City Selected")
                .font(.custom("Poppins-Bold", size: 30))
            
            Text("Please Search for a City")
                .font(.custom("Poppins-Regular", size: 20))
        }
    }
    
    // MARK: - Fetching Weather Data
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
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: City.self, inMemory: true)
}
