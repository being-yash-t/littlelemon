//
//  MenuScreen.swift
//  Little Lemon
//
//  Created by Jay Thakur on 02/01/24.
//

import SwiftUI
import CoreData

struct MenuScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack() {
                FetchedObjects(
                    predicate: buildPredicate(),
                    sortDescriptors: buildSortDescriptors()
                ) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes) { dish in
                            HStack {
                                AsyncImage(url: URL(string: dish.image!)) { image in
                                    image.image?.resizable()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(.rect(cornerRadius: 8))
                                
                                Text(dish.title!)
                                Spacer()
                                Text(dish.price!)
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search menu")
                }
                .onAppear { getMenuData() }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 0) {
                            Text("Little Lemon").font(.title)
                            Text("Nashik").font(.subheadline)
                        }.safeAreaPadding(.top)
                    }
                }
            }
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        [ NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare)) ]
    }
    
    func buildPredicate() -> NSPredicate {
        searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
    
    func getMenuData() {
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    let deleteResult = try? viewContext.execute(deleteRequest)
                    print(String(describing: deleteResult!.debugDescription))
                    
                    let menuList = try JSONDecoder().decode(MenuList.self, from: Data(data))
                    
                    menuList.menu.forEach({ item in
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.price = item.price
                        dish.image = item.image
                    })
                } catch {
                    print("Decoding failed", error)
                }
                
                try? viewContext.save()
            } else {
                let errorDescription = error == nil ? "N.A." : String(describing: error)
                print("API Failed: \(errorDescription)")
            }
        }.resume()
        
    }
}

#Preview {
    MenuScreen()
}
