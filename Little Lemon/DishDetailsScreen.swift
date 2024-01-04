//
//  DishDetailsScreen.swift
//  Little Lemon
//
//  Created by Jay Thakur on 04/01/24.
//

import SwiftUI

struct DishDetailsScreen: View {
    let dish: Dish
    var body: some View {
        List {
            AsyncImage(url: URL(string: dish.image!)!) { image in
                image.image?
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.vertical, 8)
                if image.image == nil && image.error == nil {
                    ProgressView()
                }
            }
            
            Section("About") {
                HStack {
                    Text("Category:")
                    Spacer()
                    Text(MenuItemCategory(rawValue: dish.category!)!.title)
                }
                
                HStack {
                    Text("Price:")
                    Spacer()
                    Text("$" + dish.price!).monospaced()
                }
            }
        }
        .navigationTitle(dish.title!)
        .navigationBarTitleDisplayMode(.large)
    }
}

