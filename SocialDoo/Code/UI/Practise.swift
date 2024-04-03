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
    TabView {
      SomePage()
      AnotherPage()
    }
    .tabViewStyle(.page)
    .ignoresSafeArea()
  }
}

struct SomePage: View {
  var body: some View {
    VStack {
      Text("HELLO")
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.yellow)
  }
}

struct AnotherPage: View {
  var body: some View {
    VStack {
      Text("HELLO")
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.green)
  }
}

struct PractiseGestures: View {
  var body: some View {
    Text("TAP ME")
      .padding()
      .background(Color.yellow)
      .clipShape(.capsule)
      .gesture(
        longPressGesture
          .simultaneously(with: tapGesture)
//          .sequenced(before: tapGesture)
//          .exclusively(before: tapGesture)
      )
  }
  
  func someFunction() {
    
    let rectOne = CGRect(x: 300, y: 100, width: 50, height: 100)
    let rectTwo = CGRect(x: 300, y: 100, width: 50, height: 100)
    
    rectOne.intersects(rectTwo)
    
  }
  
  var tapGesture: some Gesture {
    TapGesture(count: 3)
      .onEnded {
        print("TAPPED")
      }
  }
  
  var longPressGesture: some Gesture {
    LongPressGesture(minimumDuration: 2)
      .onEnded { press in
        print("LONG PRESSED: \(press)")
      }
  }
}

#Preview {
  Practise()
}
