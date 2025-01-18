//
//  SearchResultListItemView.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import SwiftUI

/// A view representing a single search result in the RainCheck app.
///
/// The `SearchResultListItemView` displays:
/// - The city's name.
/// - Its current temperature.
/// - An icon representing the current weather condition.
struct SearchResultListItemView: View {
    /// The ``City`` object containing the weather information to display.
    var city: City
    
    /// The body of the view.
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack {
                // City name and temperature
                VStack {
                    Text(city.name)
                        .font(.custom("Poppins-Bold", size: 24))
                    
                    HStack {
                        Text(city.temperature.map { String($0) } ?? "-")
                            .font(.custom("Poppins-Bold", size: 32))
                        
                        Text("°")
                            .font(.custom("Poppins-Regular", size: 32))
                    }
                }
                
                Spacer()
                
                // Weather condition icon
                if let conditionIconURL = city.conditionIconURL, let url = URL(string: "https:\(conditionIconURL)") {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.bottom)
                } else {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 75))
                        .foregroundStyle(.gray)
                        .symbolRenderingMode(.hierarchical)
                        .padding(.bottom)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 25)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    SearchResultListItemView(city: City(name: "Chicago"))
}
