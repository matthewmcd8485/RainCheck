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
    
    @State private var searchText = ""
    @State private var searchResults: [City] = []

    var body: some View {
        VStack {
            searchBarView
                .padding()
            
            if !searchResults.isEmpty {
                ForEach(searchResults) { city in
                    SearchResultListItemView(name: city.name)
                        .padding()
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Search Bar
    var searchBarView: some View {
        ZStack {
            
            Rectangle()
                .foregroundStyle(Color(UIColor.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            
            HStack {
                TextField("Search Location", text: $searchText)
                    .font(.custom("Poppins-Regular", size: 16))
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
    
    let mockCityData = [
        City(name: "Chicago"),
        City(name: "Los Angeles"),
        City(name: "London"),
        City(name: "Cape Town"),
        City(name: "Seattle")
    ]
    
    private func searchCities(query: String) {
        if query.isEmpty {
            searchResults = []
        } else {
            searchResults = mockCityData.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: City.self, inMemory: true)
}
