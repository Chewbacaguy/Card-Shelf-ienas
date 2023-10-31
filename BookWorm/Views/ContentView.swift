//
//  ContentView.swift
//  BookWorm
//
//  Created by Santiago Torres Alvarez on 28/10/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State private var book: Book? = nil
    @State private var selectedTemplate: Template?
    @State private var showingAddScreen = false
    @State private var showCardView = true // Add this state variable
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if !showCardView {
                    FullCardView(
                  //      selectedTemplate: self.selectedTemplate ?? Template(context: moc) // Use nil here
                    )
                } else {
                    ListCardView(
                    //    selectedTemplate: self.selectedTemplate ?? Template(context: moc) // Use nil here
                    )
                }
                
                Button(action: {
                    withAnimation {
                        showCardView.toggle()
                    }
                }) {
                    Image(systemName: showCardView ? "square.grid.2x2" : "list.dash")
                        .font(.system(size: 25))
                        .padding(.trailing, 10)
                        .foregroundColor(Color(.black))
                }
                .position(x: 355, y:  720)
                .padding(.bottom, 15)
            }
        }
        .navigationTitle("My Cards")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
                    .foregroundColor(.black)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddScreen.toggle()
                } label: {
                    Label("Add Card", systemImage: "plus")
                        .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddBookView()
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}


#Preview {
    ContentView()
}
