//
//  UserManager.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 12.03.24.
//

import Foundation

class UserManager: ObservableObject {
  public static let shared = UserManager()
  private init() {}
  
  @Published var username: String = ""
}
