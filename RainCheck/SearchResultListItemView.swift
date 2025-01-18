//
//  SearchResultListItemView.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import SwiftUI

struct SearchResultListItemView: View {
    var city: City
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack {
                VStack {
                    Text(city.name)
                        .font(.custom("Poppins-Bold", size: 24))
                    
                    HStack {
                        Text(city.humidity.map { String($0) } ?? "-")
                            .font(.custom("Poppins-Bold", size: 32))
                        
                        Text(city.humidity.map { String($0) } ?? "°")
                            .font(.custom("Poppins-Regular", size: 32))
                    }
                }
                
                Spacer()
                
                // Placeholder for the icon
                Image(systemName: "cloud.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.gray)
                    .symbolRenderingMode(.hierarchical)
                    .padding(.bottom)
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
