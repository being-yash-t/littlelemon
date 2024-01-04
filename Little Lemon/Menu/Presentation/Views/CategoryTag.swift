//
//  CategoryTag.swift
//  Little Lemon
//
//  Created by Jay Thakur on 04/01/24.
//

import SwiftUI

struct CategoryTag: View {
    let title: String
    @Binding var selected: Bool
    
    var body: some View {
        Text(title)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(selected ? .yellow : Color(.systemGroupedBackground))
            .foregroundStyle(selected ? Color.white : .primary)
            .clipShape(.rect(cornerRadius: 8))
            .onTapGesture { withAnimation(.easeInOut(duration: 0.2)) { selected = true } }
    }
}

#Preview {
    VStack {
        CategoryTag(title: "All", selected: Binding(get: {true}, set: {_ in }))
        CategoryTag(title: "All", selected: Binding(get: {false}, set: {_ in }))
    }
}
