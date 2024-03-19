//
//  TodoListView.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
  @Environment(\.modelContext) var modelContext
  @Query var allTodos: [Todo]
  
  @State var showNewTodoSheet = false
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(allTodos) { todo in
          NavigationLink(value: Router.Destination.finishTodo(todo), label: {
            Text(todo.caption)
          })
        }
        
        Button("Add new Todo") {
          showNewTodoSheet = true
        }
      }
    }
    .sheet(isPresented: $showNewTodoSheet, content: {
      newTodoView
        .presentationDetents([.medium])
    })
  }
  
  @State var newTodoCaption = ""
  var newTodoView: some View {
    VStack {
      Text("What do you want to do?")
        .font(.headline)
      
      TextField("Your Todo", text: $newTodoCaption)
      
      Button("Save") {
        let newTodo = Todo(caption: newTodoCaption)
        modelContext.insert(newTodo)
        showNewTodoSheet = false
      }
      .disabled(newTodoCaption.isEmpty)
    }
  }
}

//#Preview {
//  TodoListView()
//    .modelContainer(for: [Todo.self])
//}
