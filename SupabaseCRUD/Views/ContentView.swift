//  Date: 5/21/23
//
//  Author: Zai Santillan
//  Github: @plskz


import SwiftUI

struct ContentView: View {
    @State private var todos: [Todo] = []
    @State private var title = ""
    @State private var showingUpdateTodo = false
    
    @State private var selectedTodo: Todo?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your todo", text: $title)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                Section {
                    ForEach(todos) { todo in
                        HStack {
                            Text(todo.title)
                                .swipeActions {
                                    Button("Delete", role: .destructive) {
                                        Task {
                                            await deleteTodo(id: todo.id)
                                            self.todos = await getTodos()
                                        }
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
                print("current title: \(title)")
                
                Task {
                    await createTodo(id: UUID(), title: title)
                    self.todos = await getTodos()
                    title = ""
                }
            }
            .refreshable {
                Task {
                    self.todos = await getTodos()
                }
            }
        }
        .task {
            self.todos = await getTodos()
        }
        .sheet(item: $selectedTodo) { todo in
            UpdateTodoView(todo: todo)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


