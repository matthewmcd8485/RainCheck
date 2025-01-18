//
//  SearchResultListItemView.swift
//  RainCheck
//
//  Created by Matt McDonnell on 1/17/25.
//

import SwiftUI

struct SearchResultListItemView: View {
    var name: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.custom("Poppins-Bold", size: 28))
            
            Spacer()
        }
    }
}

#Preview {
    SearchResultListItemView(name: "Chicago")
}
