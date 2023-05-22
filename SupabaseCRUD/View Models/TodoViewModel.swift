//  Date: 5/22/23
//
//  Author: Zai Santillan
//  Github: @plskz


import Foundation
import Supabase

class TodoViewModel: ObservableObject {
    
    lazy var client = SupabaseClient(supabaseURL: Constants.SupabaseURL, supabaseKey: Constants.SupabaseKey)
    
    @Published var todos: [Todo] = []
    
    func createTodo(id: UUID, title: String) {
        let todo = Todo(id: id, title: title, done: false)
        
        let query = client
            .database
            .from("todos")
            .insert(values: todo)
        
        Task {
            _ = try? await query.execute()
            
            DispatchQueue.main.async {
                self.todos.append(todo)
                print("### createTodo - appended new todo: \(todo.title)")
            }
        }
    }
    
    func getTodos() async throws {
        let todos: [Todo] = try await client
            .database
            .from("todos")
            .execute().value
        
        DispatchQueue.main.async {
            self.todos = todos
            print("### getTodos: \(todos)")
        }
    }
    
    //        func getTodos() async throws {
    //            let query = client
    //                .database
    //                .from("todos")
    //                .select()
    //
    //            guard
    //                let response = try? query.execute(),
    //                let todos = try? response.decoded(to: [Todo].self) // doesn't work. API outdated.
    //            else {
    //                print("error decoding todos")
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //                self.todos = todos
    //            }
    //        }
    
    func updateTodos(id: UUID, newTitle: String, done: Bool) {
        let updateData = Todo(id: id, title: newTitle, done: done)
        let query = client
            .database
            .from("todos")
            .update(values: updateData)
            .eq(column: "id", value: id)
        
        Task {
            do {
                let response: [Todo] = try await query.execute().value
                print("### updateTodos: \(response)")
            } catch {
                print("### Update Error: \(error)")
            }
        }
    }
    
    func deleteTodos(id: UUID) {
        let query = client.database
            .from("todos")
            .delete()
            .match(query: ["id": id])
            .select()
            .single()
        
        Task {
            do {
                let response: Todo = try await query.execute().value
                print("### deleteTodos: \(response.title)")
            } catch {
                print("### Delete Error: \(error)")
            }
        }
    }
}
