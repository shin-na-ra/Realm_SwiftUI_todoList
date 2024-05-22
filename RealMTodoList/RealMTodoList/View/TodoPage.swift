//
//  TodoListView.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import SwiftUI

struct TodoPage: View {
    
    @ObservedObject private var viewModel = TodoListViewModel()
    @State var isAlert: Bool = false
    @State var userInput : String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @FocusState var isTextFieldFoucsed: Bool
    
    let todayDate = Date.now
    
    
    var body: some View {
        
        // startdate기준으로 최신 메모가 가장 위에 오도록 정렬
        let todoLists = viewModel.todoLists
        
        NavigationView(content: {
            ScrollView(content: {
                List(todoLists) { todolist in
                    NavigationLink(destination: TodoDetailPage()) {
                            VStack(alignment: .leading, content: {
                                Text("성명 : \(todolist.title)")
                                Text("학변 : \(todolist.startdate)")
                                Text("학변 : \(todolist.enddate)")
                                    .font(.system(size: 14))
                            }) // VStack
                        } // NavigationLink
                }// List
            })
            .navigationTitle("TodoList")
            .navigationBarTitleDisplayMode(.inline)
            .font(.system(.body, design: .rounded))
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Image(systemName: "plus.circle")
                        .onTapGesture(perform: {
                            isAlert.toggle()
                        })
                        .sheet(isPresented: $isAlert, content: {
                            VStack(content: {
                                
                                
                                Text("할 일 :")
                                    .bold()
                                    .padding(.trailing, 170)
                                    
                                TextField("", text : $userInput)
                                    .padding()
                                    .frame(width: 250)
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.leading)
                                    .keyboardType(.default)
                                    .focused($isTextFieldFoucsed)
                                    .padding(.bottom, 60)
                                
                                    HStack {
                                        Spacer()
                                        Text("시작일 : ")
                                        
                                        DatePicker(
                                            "",
                                            selection: $startDate,
                                            displayedComponents: [.date]
                                        )
                                        .frame(width: 150)
                                        .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어로 설정
                                        .tint(.black)
                                        
                                        Spacer()
                                    }
                                    .padding(.bottom, 10)
                                
                                    HStack {
                                        Spacer()
                                        
                                        Text("종료일 : ")
                                        
                                        DatePicker(
                                            "",
                                            selection: $endDate,
                                            displayedComponents: [.date]
                                        )
                                        .frame(width: 150)
                                        .environment(\.locale, Locale(identifier: "ko_KR")) // 한국어로 설정
                                        .tint(.black)
                                        
                                        Spacer()
                                    }
                                    .padding(.bottom, 60)
                                    

                                VStack {
                                    Button("추가", action: {
                                        isTextFieldFoucsed = false
                                        isAlert.toggle()
                                        viewModel.addTodoList(title: userInput, startdate: startDate, enddate: endDate, status: 0)
                                    })
                                    .tint(.white)
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.capsule)
                                    .background(Color.primary)
                                    .cornerRadius(30)
                                    .controlSize(.large)
                                }
                                .frame(width: 200, height: 50) // 버튼의 크기 조정
                            })
                        })
                })
            })
        })

        
    }// body
}

#Preview {
    TodoPage( )
}
