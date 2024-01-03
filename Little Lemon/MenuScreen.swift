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
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                VStack(alignment: .leading)  {
                    Text("Little Lemon")
                        .font(.title)
                        .padding(.horizontal)
                    Text("NY")
                        .font(.subheadline)
                        .padding(.horizontal)
                    Text("View all the dishes available & order from the app")
                        .font(.caption)
                        .padding(.horizontal)
                    
                    SearchBar(text: $searchText)
                    
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
                    }.safeAreaPadding(.top, 0)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .onAppear { getMenuData() }
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        [ NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare)) ]
    }
    
    func buildPredicate() -> NSPredicate {
        searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
    
    private func clearDatabase() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Dish")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        let deleteResult = try! viewContext.execute(deleteRequest) as! NSBatchDeleteResult
        /// Sync changes to memory
        let changes: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult.result as! [NSManagedObjectID]
        ]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [viewContext])
    }
    
    private func getMenuData() {
        clearDatabase()
        
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
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
    MenuScreen()
}
