//
//  TodoListView.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import SwiftUI
import RealmSwift

struct TodoPage: View {
    
    @ObservedObject private var viewModel = TodoListViewModel() // viewModel
    @State var isAlert: Bool = false        // 할일 작성 alert
    @State var userInput : String = ""      // 할일 text
    @State var startDate: Date = Date()     // 시작일
    @State var endDate: Date = Date()       // 종료일
    @FocusState var isTextFieldFoucsed: Bool    // 커서 focus
    @State var result: Bool = true              // addaction 결과값
    @State var resultStatus: Bool = true       // addaction 결과값
    @Environment(\.dismiss) var dismiss         // 창 사라지게
    
    
    @State var alertTitle: String = ""          // 확인 alert창 제목
    @State var alertMessage: String = ""        // 확인 alert창 메세지
    @State var alertButton: String = ""         // 확인 alert창 버튼
    @State var alertOpen: Bool = false          // 확인 alert창 bool
    
    @State var isShowingConfirmation = false  //actionSheet 여부
    @State var selectedIndex: Int? // 선택한 값
    
    
    let todayDate = Date.now
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todoLists.indices, id: \.self) { index in
                    let todolist = viewModel.todoLists[index]
                    
                    NavigationLink(destination: {
                        TodoDetailPage(id: todolist.id.stringValue, title: todolist.title, startdate: todolist.startdate, enddate: todolist.enddate, status: todolist.status)
                    }, label: {
                        VStack(alignment: .leading, content: {
                            Text(todolist.title)
                                .bold()
                                .foregroundStyle(todolist.status == 1 ? Color.black.opacity(0.5) : Color.black)
                            HStack(content: {
                                Text(dateFormatter.string(from: todolist.startdate))
                                Text("~")
                                Text(dateFormatter.string(from: todolist.enddate))
                            })
                            .foregroundStyle(todolist.status == 1 ? Color.black.opacity(0.3) : Color.black)
                            .padding(.top, 5)
                            .font(.system(size: 15))
                        })
                    })
                    .onLongPressGesture{
                        selectedIndex = index
                        isShowingConfirmation = true
                    }
                }
                .onDelete(perform: { indexSet in
                    // 여기에 삭제 로직을 추가하세요.
                    for index in indexSet {
                        let idValue = viewModel.todoLists[index].id.stringValue
                        viewModel.deleteTodoList(id: idValue)
                    }
                })
            } // list
            .onAppear {
                viewModel.setupObserver()
            }
            .font(.system(.body, design: .rounded))
            .alert(isPresented: $isShowingConfirmation, content: {
                Alert(
                    title: Text(
                        viewModel.todoLists[selectedIndex!].status == 0
                        ? "완료처리하시겠습니까?"
                        : "완료해제 하시겠습니까?"
                    ),
                    message: nil,
                    primaryButton: .default(Text("예")) {
                        if let index = selectedIndex {
                            let idValue = viewModel.todoLists[index].id.stringValue
                            let statusValue = viewModel.todoLists[index].status
                            
                            self.resultStatus = viewModel.updateStatus(id: idValue, status: statusValue == 0 ? 1 :0)
                            isShowingConfirmation = false
                        }
                    },
                    secondaryButton: .cancel(Text("아니요"))
                )
            })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Image(systemName: "plus.circle")
                    .onTapGesture(perform: {
                        isAlert.toggle()
                    })
                    .padding(.trailing, 10)
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
                                Button("추가하기", action: {
                                    alertOpen.toggle()
                                    isTextFieldFoucsed = false
                                    
                                    if userInput.isEmpty{
                                        showAlert(title: "경고", message: "데이터를 입력하세요.", button: "확인")
                                    } else {
                                        self.result = viewModel.addTodoList(title: userInput, startdate: startDate, enddate: endDate, status: 0)
                                        
                                        if self.result {
                                            showAlert(title: "알림", message: "추가되었습니다.", button: "확인")
                                        } else {
                                            showAlert(title: "알림", message: "추가에 실패했습니다.", button: "확인")
                                        }
                                        
                                        alertOpen = true
                                    }
                                    
                                    self.userInput = ""
                                    startDate = Date.now
                                    endDate = Date.now
                                    print("## realm file dir -> \(Realm.Configuration.defaultConfiguration.fileURL!)")
                                })
                                .tint(.white)
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                .background(Color("myColor1"))
                                .cornerRadius(30)
                                .controlSize(.large)
                                .frame(width: 200, height: 50) // 버튼의 크기 조정
                                .alert(isPresented: $alertOpen, content: {
                                    Alert(
                                        title: Text(alertTitle),
                                        message: Text(alertMessage),
                                        dismissButton: .default(Text(alertButton), action: {
                                            // 알림 창을 닫는 액션을 여기에 추가합니다.
                                            alertOpen = false
                                            isAlert = false
                                        })
                                    )
                                })
                            }
                        })

                    })
                    .navigationTitle("할 일 목록")
                    .navigationBarTitleDisplayMode(.inline)
                    })// ToolbarItem
                    
    })
        }
        
    }// body
    
    func showAlert(title: String, message: String, button: String) {
        alertTitle = title
        alertMessage = message
        alertButton = button
        alertOpen = true
        dismiss()
    }
}

#Preview {
    TodoPage( )
}
