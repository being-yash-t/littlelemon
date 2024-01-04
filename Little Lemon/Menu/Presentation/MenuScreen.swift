//
//  MenuScreen.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI
import CoreData

struct MenuScreen: View {
    @StateObject var viewModel: MenuViewModel = MenuViewModel()
    
    var body: some View {
        FetchedObjects(
            predicate: buildPredicate(),
            sortDescriptors: buildSortDescriptors()
        ) { (dishes: [Dish]) in
            VStack {
                Image("little-lemon").resizable().scaledToFit().frame(height: 100).padding([.top, .horizontal])
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist")
                    .font(.caption)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                SearchBar(text: $viewModel.searchText)
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        CategoryTag(
                            title: "All",
                            selected: Binding(
                                get: { viewModel.selectedCategory == nil },
                                set: { newValue in
                                    if newValue { viewModel.selectedCategory = nil }
                                })
                        )
                        ForEach(MenuItemCategory.allCases) { category in
                            CategoryTag(
                                title: category.title,
                                selected: Binding(
                                    get: { category == viewModel.selectedCategory },
                                    set: { newValue in
                                        if newValue { viewModel.selectedCategory = category }
                                    }
                                )
                            )
                            
                        }
                    }.padding()
                }
                if viewModel.loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if dishes.isEmpty {
                    Spacer()
                    Text("No Items :(")
                    Spacer()
                } else {
                    List {
                        ForEach(dishes) { dish in
                            NavigationLink(destination: DishDetailsScreen(dish: dish)) {
                                HStack {
                                    AsyncImage(url: URL(string: dish.image!)) { image in
                                        image.image?.resizable()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(.rect(cornerRadius: 8))
                                    
                                    Text(dish.title!)
                                    Spacer()
                                    Text("$" + dish.price!)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .onAppear { viewModel.getMenuData() }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        [ NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare)) ]
    }
    
    func buildPredicate() -> NSPredicate {
        let searchPredicate = viewModel.searchText.isEmpty
        ? NSPredicate(value: true)
        : NSPredicate(format: "title CONTAINS[cd] %@", viewModel.searchText)
        
        if viewModel.selectedCategory != nil {
            return NSCompoundPredicate(type: .and, subpredicates: [
                searchPredicate,
                NSPredicate(format: "category == %@", viewModel.selectedCategory!.rawValue)
            ])
        } else {
            return searchPredicate
        }
    }
}

#Preview {
    MenuScreen()
}
