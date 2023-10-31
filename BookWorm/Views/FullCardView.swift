        //
        //  FullCardView.swift
        //  BookWorm
        //
        //  Created by Santiago Torres Alvarez on 28/10/23.
        //
        import SwiftUI
        import CoreData
        struct FullCardView: View {
         //   let book: Book
          //     let selectedTemplate: Template
            @State private var isInsideBookActive = false
               @Environment(\.managedObjectContext) var moc
               @Environment(\.dismiss) var dismiss
               @State private var showingAddScreen = false
                @FetchRequest(entity: Book.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \Book.title, ascending: true),
                    NSSortDescriptor(keyPath: \Book.author, ascending: true)
                ]) var books: FetchedResults<Book>
            
         
          

            var body: some View {
                NavigationView {
                    ZStack {
                        if books.isEmpty {
                            Text("No books to display")
                                .foregroundColor(.black)
                        } else {
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(books) { book in
                                        FullCardRectangle(book: book)
                                                    .padding(5)
                                                }
                                    }
                                }
                                .padding(20)
                            }
                        }


                        Button(action: {
                            showingAddScreen.toggle()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 25))
                                .padding(.trailing, 10)
                                .foregroundColor(Color(.black))
                        }
                        .position(x: UIScreen.main.bounds.width - 30, y: UIScreen.main.bounds.height - 30)
                        .padding(.bottom, 15)
                    }
                    .navigationTitle("My Cards")
                }
            }


        struct FullCardRectangle: View {
            let book: Book
            
            
            public var colorDictionary: [String: Color] = [
                           "black": .black,
                           "red": .red,
                           "pink": .pink,
                           "blue": .blue,
                           "yellow": .yellow,
                           "green": .green,
                           "brown": .brown
                       ]
            
            @State private var isInsideBookActive = false

            var body: some View {
                ZStack {
                    CardBackground(book: book)
                        
                    
                    Image(systemName: book.icon ?? "icloud")
                        .resizable()
                        .frame(width: 40, height: 39)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                        .position(CGPoint(x: 305, y: 600.0))

                    Image(systemName: book.icon ?? "icloud")
                        .resizable()
                        .frame(width: 40, height: 39)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                        .position(CGPoint(x: 45, y: 70.0))

                    Image(systemName: book.icon ?? "icloud")
                        .resizable()
                        .frame(width: 77, height: 74)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                        .position(CGPoint(x: 170, y: 310.0))
                    Text(book.name ?? "Free Read")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                        .bold()
                        .frame(width: 223.9243, height: 50.26871, alignment: .center)
                        .position(CGPoint(x: 170.0, y: 200.0))
                    
                    Text(book.title ?? "Title")
                        .padding(5)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                        .bold()
                        .frame(width: 223.9243, height: 50.26871, alignment: .center)
                        .position(CGPoint(x: 170.0, y: 240.0))

                    Text(book.review ?? "No Description")
                        .font(Font.custom("Inter", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                        .frame(width: 210.21463, height: 36.55907, alignment: .center)
                        .position(CGPoint(x: 170.0, y: 370.0))
                    
                    
                    
                }
                .onTapGesture {
                    isInsideBookActive = true
                }
                .fullScreenCover(isPresented: $isInsideBookActive) {
                    DetailView(book: book)
                }
            }
        }

        struct CardBackground: View {
            let book: Book

            var body: some View {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 340, height: 605)
                    .background(Color.white)
                    .cornerRadius(11)
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                            .inset(by: 0.5)
                            .stroke(Color(book.color ?? "gray"), lineWidth: 4)
                    )
            }
        }

        //struct FullCardView_Previews: PreviewProvider {
        //    static var previews: some View {
        //        FullCardView(book:_book)
        //    }
        //}
        //
