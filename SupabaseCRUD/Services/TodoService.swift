//  Date: 5/26/23
//
//  Author: Zai Santillan
//  Github: @plskz


import Foundation

func getTodos() async -> [Todo] {
    let query = client
        .database
        .from("todos")
        .select()
    
    let resp: [Todo] = try! await query.execute().value
    
    print("getTodos = \(resp)")
    
    return resp
}

func createTodo(id: UUID, title: String) async {
    let todo = Todo(id: id, title: title, done: false)
    
    let query = client
        .database
        .from("todos")
        .insert(values: todo)
    
    print("createTodo = \(query)")
    
    try! await query.execute()
}

func updateTodo(id: UUID, newTitle: String, done: Bool) async {
    let todo = Todo(id: id, title: newTitle, done: done)
    
    let query = client
        .database
        .from("todos")
        .update(values: todo)
        .eq(column: "id", value: id)
    
    print("updateTodo = \(query)")
    
    try! await query.execute()
}

func deleteTodo(id: UUID) async {
    let query = client
        .database
        .from("todos")
        .delete()
        .eq(column: "id", value: id)
    
    print("deleteTodo = \(query)")
    
    try! await query.execute()
}
