//
//  CityView.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/18/25.
//

import SwiftUI

struct CityView: View {
    
    var city: City
    
    var body: some View {
        VStack {
            if let conditionIconURL = city.conditionIconURL, let url = URL(string: "https:\(conditionIconURL)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125, height: 125)
                } placeholder: {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.gray)
                        .symbolRenderingMode(.hierarchical)
                        .padding(.bottom)
                }
                .padding(.bottom)
            }
            
            // City name
            HStack {
                Text(city.name)
                    .font(.custom("Poppins-Bold", size: 32))
                
                Image(systemName: "location.fill")
                    .font(.system(size: 24))
            }
            
            HStack {
                Text(city.temperature.map { String($0) } ?? "-")
                    .font(.custom("Poppins-Bold", size: 72))
                
                Text("°")
                    .font(.custom("Poppins-Regular", size: 72))
            }

            detailView
                .padding(.horizontal, 50)
        }
    }
    
    var detailView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack {
                // Humidity
                VStack {
                    Text("Humidity")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundStyle(.tertiary)
                    
                    HStack(spacing: 0) {
                        Text(city.humidity.map { String($0) } ?? "-")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundStyle(.secondary)
                        
                        Text("%")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // UV Index
                VStack {
                    Text("UV")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundStyle(.tertiary)
                    
                    Text(city.uvIndex.map { String($0) } ?? "-")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundStyle(.secondary)
                    
                }
                
                Spacer()
                
                // Feels Like
                VStack {
                    Text("Feels Like")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundStyle(.tertiary)
                    
                    HStack(spacing: 0) {
                        Text(city.feelsLike.map { String($0) } ?? "-")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundStyle(.secondary)
                        
                        Text("°")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundStyle(.secondary)
                    }
                    
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    CityView(city: City(name: "Chicago"))
}
