import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
      let book: Book
        @Environment(\.managedObjectContext) var moc
        @Environment(\.dismiss) var dismiss
        @State private var showingDeleteAlert = false
        @State private var note = ""
        @State private var newTask = ""
        @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: true)])
        var tasks: FetchedResults<Task>

        var selectedTemplate: Template?

        init(book: Book) {
            self.book = book

            if let templateName = book.template?.name {
                // Fetch the selected template based on the template name
                let fetchRequest: NSFetchRequest<Template> = Template.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", templateName)
                
                do {
                    selectedTemplate = try moc.fetch(fetchRequest).first
                } catch {
                    print("Error fetching template: \(error)")
                }
            }
        }
    
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
        Spacer()
        ScrollView {
            Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .padding()
                    .foregroundColor(.black)
                   
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(23)
                    .opacity(0.3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(10)
                    .edgesIgnoringSafeArea(.all)
                    .shadow(radius: 3)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 9, height: 10))
                            .inset(by: 0.5)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(10)
                    )
                
                
                
                VStack {
                    HStack {
                        Image(systemName: book.icon ?? "icloud")
                            .resizable()
                            .foregroundColor(colorDictionary[book.color ?? "black"])
                            .frame(width: 23, height: 22)
                            .position(x: 20, y: 20)
                    }
                    .padding(10)
                    
                    VStack {
                        Text(book.name ?? "Free Read")
                            .font(.title)
                            .bold()
                            .foregroundColor(colorDictionary[book.color ?? "black"])
                        
                        Text(book.author ?? "Unknown Author")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Description:")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                    
                    Text(book.review ?? "No Description")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 5)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                    
                    Spacer()
                    RatingView(rating: .constant(Int(book.rating)))
                        .font(.title3)
                        .padding(.bottom, 3)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                    
                    VStack(alignment: .leading) {
                        List {
                            Section(header: Text("Tasks")) {
                                TextField("Add a new task", text: $newTask)
                                
                                Button("Add") {
                                    if !newTask.isEmpty {
                                        let task = Task(context: moc)
                                        task.title = newTask
                                        task.isCompleted = false
                                        task.date = Date()
                                        task.book = book
                                        newTask = ""
                                        try? moc.save()
                                    }
                                }
                                
                                ForEach(tasks) { task in
                                    Text(task.title ?? "Sample Task")
                                        .onTapGesture {
                                            // Handle the tap action, e.g., navigation or interaction
                                        }
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        let task = tasks[index]
                                        moc.delete(task)
                                    }
                                    try? moc.save()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .cornerRadius(8)
                    //.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 0.3))
                    .padding(.horizontal, 10)
                    
                   
                    Text("Leave a quick note")
                        .font(.headline)
                        .padding(.top, 10)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(colorDictionary[book.color ?? "black"])
                    
                    VStack {
                        TextEditor(text: $note)
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.2))
                            .shadow(radius: 1)
                    }
                    .padding(.horizontal, 10)
                    
                    Button("Save") {
                        book.note = note
                        try? moc.save()
                        dismiss()
                    }
                    .padding(.bottom, 10)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .buttonStyle(BorderlessButtonStyle())
                    
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    }
                    .padding(20)
                    
                    HStack {
                        Image(systemName: book.icon ?? "icloud")
                            .resizable()
                            .frame(width: 23, height: 22)
                            .position(x: 320, y: 0)
                            .foregroundColor(colorDictionary[book.color ?? "black"])
                    }
                }
                .padding()
            }
            
        }
        
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
    }
    
    
    
    func deleteBook() {
        moc.delete(book)
        dismiss()
    }
}
