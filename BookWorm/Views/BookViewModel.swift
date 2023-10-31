//
//  BookViewModel.swift
//  BookWorm
//
//  Created by Santiago Torres Alvarez on 29/10/23.
//

import Foundation
import CoreData
import Combine

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        // Fetch books from Core Data when the view model is initialized
        fetchBooks()
    }
    
    func fetchBooks() {
        // Access the managed object context from the PersistenceController or your app's environment
        let context = PersistenceController.shared.container.viewContext
        
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        do {
            books = try context.fetch(request)
        } catch {
            print("Error fetching books: \(error)")
        }
    }
    
    func addBook(title: String, author: String, rating: Int16, template: String, review: String, icon: String, color: String) {
        // Access the managed object context
        let context = PersistenceController.shared.container.viewContext
        
        let newBook = Book(context: context)
        newBook.title = title
        newBook.author = author
        newBook.rating = rating
  //      selectedTemplate.template = template
        newBook.review = review
        newBook.icon = icon
        newBook.color = color
        
        do {
            try context.save()
            // Update the @Published property to trigger a refresh in the UI
            fetchBooks()
        } catch {
            print("Error saving book: \(error)")
        }
    }
    
    // Add more methods for updating and deleting books if needed
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "BookWorm")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading store: \(error)")
            }
        }
    }
}
