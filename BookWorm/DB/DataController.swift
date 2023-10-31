//
//  DataController.swift
//  BookWorm
//
//  Created by Santiago Torres Alvarez on 26/10/23.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "BookWorm")
    
    init(){
        container.loadPersistentStores{description, error in
            if let error = error {
                print("Core data failed to load:  \(error.localizedDescription)")
            }
        }
    }
}
