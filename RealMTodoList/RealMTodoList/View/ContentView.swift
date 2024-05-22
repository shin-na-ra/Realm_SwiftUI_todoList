//
//  ContentView.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection,
                content:  {
            
        })
    }
}

#Preview {
    ContentView()
}
