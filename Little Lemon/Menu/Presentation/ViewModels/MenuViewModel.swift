//
//  MenuViewModel.swift
//  Little Lemon
//
//  Created by Jay Thakur on 04/01/24.
//

import Foundation
import CoreData

class MenuViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var searchText = ""
    @Published var selectedCategory: MenuItemCategory?
    @Published var loading: Bool = false
    
    init() { }
    
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
    
    func getMenuData() {
        loading = true
        clearDatabase()
        
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
//                    print(String(decoding: data, as: UTF8.self))
                    let menuList = try JSONDecoder().decode(MenuList.self, from: Data(data))
                    menuList.menu.forEach({ let _ = self.dishFromMenuItem($0) })
                } catch {
                    print("Decoding failed", error)
                }
                
                try? self.viewContext.save()
            } else {
                let errorDescription = error == nil ? "N.A." : String(describing: error)
                print("API Failed: \(errorDescription)")
            }
            DispatchQueue.main.async { self.loading = false }
        }.resume()
    }
    
    private func dishFromMenuItem(_ item: MenuItem) -> Dish {
        let dish = Dish(context: viewContext)
        dish.title = item.title
        dish.price = item.price
        dish.image = item.image
        dish.category = item.category
        return dish
    }
}
