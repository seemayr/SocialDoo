//
//  Todo.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 19.03.24.
//

import Foundation
import SwiftData

@Model
class Todo {
  @Attribute(.unique) var id: UUID = UUID()
  var caption: String
  var createdAt: Date = Date.now
  
  var finishedAt: Date?
  
  init(caption: String, finishedAt: Date? = nil) {
    self.caption = caption
    self.finishedAt = finishedAt
  }
}
