//  Date: 5/22/23
//
//  Author: Zai Santillan
//  Github: @plskz


import SwiftUI

struct UpdateTodoView: View {
    @StateObject var model: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var newTitle: String
    @State private var done: Bool
    
    let types = [true, false]
    let todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        self._newTitle = State(initialValue: todo.title)
        self._done = State(initialValue: todo.done)
        self._model = StateObject(wrappedValue: TodoViewModel())
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("New Title", text: $newTitle)
                    .autocorrectionDisabled(true)
                
                Picker("Done", selection: $done) {
                    ForEach(types, id: \.self) { value in
                        Text(value ? "True" : "False")
                    }
                }
            }
            .navigationTitle("Update todo")
            .toolbar {
                Button("Save") {
                    if newTitle.isEmpty {
                        newTitle = "Unknown"
                    }
                    
                    model.updateTodos(id: todo.id, newTitle: newTitle, done: done)
                    dismiss()
                }
            }
        }
    }
}

//struct UpdateTodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateTodoView(todo: Todo(id: UUID(), title: "Exercise", done: false))
//    }
//}
