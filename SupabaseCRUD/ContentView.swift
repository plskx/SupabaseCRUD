//  Date: 5/21/23
//
//  Author: Zai Santillan
//  Github: @plskz


import SwiftUI

struct ContentView: View {
    @StateObject private var model = TodoViewModel()
    @State private var title = ""
    @State private var showingUpdateTodo = false
    
    @State private var selectedTodo: Todo?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your todo", text: $title)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                }
                
                Section {
                    ForEach(model.todos) { todo in
                        HStack {
                            Text(todo.title)
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        model.deleteTodos(id: todo.id)
                                    }
                                    
                                    Button("Update") {
                                        selectedTodo = todo
                                        showingUpdateTodo = true
                                    }
                                    .tint(.blue)
                                }
                                .foregroundColor(todo.done ? .green : .black)
                        }
                    }
                }
            }
            .navigationTitle("Rakun Todolist")
            .onSubmit {
                model.createTodo(id: UUID(), title: title)
                title = ""
            }
            .refreshable {
                try? await model.getTodos()
            }
            
        }
        .task {
            try? await model.getTodos()
        }
        .sheet(item: $selectedTodo) { todo in
            UpdateTodoView(todo: todo)
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
