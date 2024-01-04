//
//  SearchBar.swift
//  Little Lemon
//
//  Created by Jay Thakur on 04/01/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var showCancelButton = false
    @State var showClear = false
    @FocusState private var focusedField: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                TextField("Search...", text: $text, onEditingChanged: { isEditing in
                    withAnimation { showCancelButton = isEditing }
                })
                .focused($focusedField)
                .onChange(of: text) {
                    withAnimation {
                        showClear = text.isEmpty ? false : true
                    }
                }
                if showClear {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(8)
            
            if showCancelButton {
                Button("Cancel") {
                    withAnimation {
                        text = ""
                        showCancelButton = false
                        focusedField = false
                    }
                }
                .padding(.leading, 4)
            }
        }.padding(.horizontal)
    }
}

#Preview {
    SearchBar(text: Binding(get: {"value"}, set: {_ in }))
}
