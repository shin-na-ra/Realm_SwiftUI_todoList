//
//  ContentView.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 0
//    let todoVM : ViewModel
    
    var body: some View {
        TabView(selection: $selection,
                content:  {
            TodoPage()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("TodoList")
                }
                .tag(1)
            
            SettingPage()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Setting")
                }
                .tag(2)
        })
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
