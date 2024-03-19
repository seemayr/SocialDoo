//
//  StackRouter.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import SwiftUI

struct StackRouter<Content: View>: View {
  @StateObject var router = Router()
  
  let content: () -> Content
  
  var body: some View {
    NavigationStack(path: $router.navigationPath) {
      content()
        .navigationDestination(for: Router.Destination.self) { dest in
          switch dest {
          case .todoList:
            TodoListView()
          case .finishTodo(let todo):
            FinishTodoView(todo: todo)
          case .profileView(let user):
            ProfileView(profileUser: user)
          case .userList:
            UserListView()
          case .feedView:
            FeedView()
          }
        }
    }
    .environmentObject(router)
  }
}

class Router: ObservableObject {
  @Published var navigationPath = NavigationPath()
  
  func popToRoot() {
    navigationPath.removeLast(navigationPath.count)
  }
  
  func push(_ destination: Destination) {
    navigationPath.append(destination)
  }
  
  enum Destination: Hashable {
    case todoList
    case userList
    case finishTodo(Todo)
    case profileView(SocialUser)
    case feedView
  }
}
