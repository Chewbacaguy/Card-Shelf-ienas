import SwiftUI
import CoreData

struct ListCardView: View {
    //    let book: Book
    //       let selectedTemplate: Template
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingAddScreen = false
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    private var colorDictionary: [String: Color] = [
        "black": .black,
        "red": .red,
        "pink": .pink,
        "blue": .blue,
        "yellow": .yellow,
        "green": .green,
        "brown": .brown
    ]
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        HStack {
           
                            Image(systemName: book.icon ?? "icloud")
                                .resizable()
                                .padding(.trailing, 5)
                                .frame(width: 35, height: 27, alignment: .leading)
                                .foregroundColor(colorDictionary[book.color ?? "black"])
//                            EmojiRatingView(rating: Int16(book.rating))
//                                 .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Title Ex")
                                    .font(.headline)
                                Text(book.author ?? "Author")
                                    .foregroundColor(.secondary)
                                Text(book.name ?? "name")
                                    .font(.footnote)
                            }
                        }
                        
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("My Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Card", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView().environment(\.managedObjectContext, moc)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
