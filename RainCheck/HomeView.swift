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
                    
                    if !searchResults.isEmpty {
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
                    if let savedCity = savedCities.first, !hideSavedCityView {
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
                        // Handle search on return key press
                        if searchText.count > 2 {
                            searchCities(query: searchText)
                            hideSavedCityView = true
                        }
                    }
                    .padding(.horizontal)
                
                if searchText.count > 0 {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                            .symbolRenderingMode(.hierarchical)
                            .padding(.trailing)
                    }
                }
                
                Button(action: {
                    // Requires 3 characters before searching
                    if searchText.count > 2 {
                        searchCities(query: searchText)
                        
                        hideSavedCityView = true
                    } else {
                        
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
    
    var placeholderView: some View {
        VStack {
            Text("No City Selected")
                .font(.custom("Poppins-Bold", size: 30))
            
            Text("Please Search for a City")
                .font(.custom("Poppins-Regular", size: 20))
            
        }
    }
    
    let mockCityData = [
        City(name: "Chicago"),
        City(name: "Los Angeles"),
        City(name: "London"),
        City(name: "Cape Town"),
        City(name: "Seattle")
    ]
    
    // MARK: - City Searching & Saving
    private func searchCities(query: String) {
        if query.isEmpty {
            searchResults = []
        } else {
            searchResults = mockCityData.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
    
    private func saveCity(_ city: City) {
        if let existingCity = savedCities.first {
            modelContext.delete(existingCity)
        }
        
        modelContext.insert(city)
        
        try? modelContext.save()
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: City.self, inMemory: true)
}
