//
//  Practise.swift
//  SocialDoo
//
//  Created by Dominik Seemayr on 20.03.24.
//

import SwiftUI
import SFSafeSymbols

struct Practise: View {
  var body: some View {
    VStack {
      Image(systemSymbol: .bubbleRight)
      Label("ABC", systemSymbol: .alarm)
      
      Image(systemName: "bubble.right")
      Label("ABC", systemImage: "bubble.right")
    }
    .font(.largeTitle)
    
  }
}


#Preview {
  Practise()
}
