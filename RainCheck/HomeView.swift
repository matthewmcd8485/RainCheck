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
    @Query private var cities: [City]

    var body: some View {
        Text("Hello")
    }
}

#Preview {
    HomeView()
        .modelContainer(for: City.self, inMemory: true)
}
