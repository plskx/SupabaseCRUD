//  Date: 5/21/23
//
//  Author: Zai Santillan
//  Github: @plskz


import SwiftUI

struct ContentView: View {
    @StateObject private var model = TodoViewModel()
    @State private var title = ""
    
    var body: some View {
        VStack {
            TextField("Todo Title", text: $title)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            Button("Create Todo") {
                model.createTodo(id: .random(in: 0...1000000), title: title)
            }
            
            List(model.todos) { todo in
                Text("\(todo.title) (id: \(todo.id))")
                    .swipeActions {
                        Button("Update") {
                            model.updateTodos(id: todo.id)
                        }
                        Button("Delete", role: .destructive) {
                            model.deleteTodos(id: todo.id)
                        }
                    }
            }
            .refreshable {
                try? await model.getTodos()
            }
        }
        .task {
            try? await model.getTodos()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
