//
//  TodoListView.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import SwiftUI
import RealmSwift

struct TodoPage: View {
    
    @ObservedObject private var viewModel = TodoListViewModel()
    @State var isAlert: Bool = false
    @State var userInput : String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @FocusState var isTextFieldFoucsed: Bool
    @Environment(\.dismiss) var dismiss
    
    let todayDate = Date.now
    
    
    var body: some View {
        
        // startdate기준으로 최신 메모가 가장 위에 오도록 정렬
        let todoLists = viewModel.todoLists
        
        NavigationView(content: {
                List(todoLists) { todolist in
                    NavigationLink(destination: {
                        TodoDetailPage()
                    }, label: {
                        VStack(content: {
                            Text(todolist.title)
                                .bold()
                            Text(todolist.startdate, style: .date)
                            Text(todolist.enddate, style: .date)
                        })
                    })
                }// List
                .onAppear {
                    viewModel.setupObserver()
                }
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
                                        showDatePicker("시작일", variable: $startDate)
                                        Spacer()
                                    }
                                    .padding(.bottom, 10)
                                
                                    HStack {
                                        Spacer()
                                        showDatePicker("종료일", variable: $endDate)
                                        Spacer()
                                    }
                                    .padding(.bottom, 60)
                                    

                                VStack {
                                    Button("추가", action: {
                                        isTextFieldFoucsed = false
                                        isAlert.toggle()
                                        viewModel.addTodoList(title: userInput, startdate: startDate, enddate: endDate, status: 0)
                                        dismiss()
                                        
                                        userInput = ""
                                        startDate = Date.now
                                        endDate = Date.now
                                        print("## realm file dir -> \(Realm.Configuration.defaultConfiguration.fileURL!)")
                                    })
                                    .tint(.white)
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.capsule)
                                    .background(Color("MyColor"))
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
