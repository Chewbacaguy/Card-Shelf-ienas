import SwiftUI
import CoreData



struct TemplateInfo {
    let color: Color
    let icon: String
}

let templateData: [String: TemplateInfo] = [
    "Free Read": TemplateInfo(color: .red, icon: "book"),
    "Studying": TemplateInfo(color: .pink, icon: "brain"),
    "Research": TemplateInfo(color: .blue, icon: "eye"),
    "Homework": TemplateInfo(color: .yellow, icon: "house"),
    "Curiosity": TemplateInfo(color: .green, icon: "pyramid"),
    "Self-Help": TemplateInfo(color: .yellow, icon: "scale.3d"),
    "Manual": TemplateInfo(color: .brown, icon: "magazine"),
    // Add more template names, colors, and icons here
]

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var template = ""
    @State private var review = ""
    @State private var color = ""
    
    // Template data including color and icon
    let templateData: [String: TemplateInfo] = [
        "Free Read": TemplateInfo(color: .red, icon: "book"),
        "Studying": TemplateInfo(color: .pink, icon: "brain"),
        "Research": TemplateInfo(color: .blue, icon: "eye"),
        "Homework": TemplateInfo(color: .yellow, icon: "house"),
        "Curiosity": TemplateInfo(color: .green, icon: "pyramid"),
        "Self-Help": TemplateInfo(color: .yellow, icon: "scale.3d"),
        "Manual": TemplateInfo(color: .brown, icon: "magazine")
    ]
    
    var templates: [String] {
           Array(templateData.keys)
       }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Template", selection: $template) {
                        ForEach(templates, id: \.self) { templateName in
                            Text(templateName)
                        }
                    }
                }
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: { Text("Write a Quick Note") }
                Section {
                    Button("Save") {
                        guard let templateInfo = templateData[template] else { return }
                        
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.name = template
                        print(template)
                        //newBook.template = selectedTemplate
                        newBook.review = review
                        newBook.icon = templateInfo.icon
                        newBook.color = templateInfo.color.description
                        
                        try? moc.save()
                        dismiss()
                    }
                }
            }.navigationTitle("Add Card")
        }
    }
}



struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
