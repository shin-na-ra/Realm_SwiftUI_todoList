//
//  TodoDetailPage.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import SwiftUI
import RealmSwift

struct TodoDetailPage: View {
    @ObservedObject private var viewModel = TodoListViewModel()
    @State var id : String = ""
    @State var title: String = ""
    @State var startdate = Date()
    @State var enddate = Date()
    @State var status : Int = 0
    
    @State private var isAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    @FocusState var isTextFieldFoucsed: Bool
    @State var result: Bool = true
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var alertButton: String = ""
    
//    @State var todolist: TodoList
    
    var body: some View {
        ScrollView {
            VStack(content: {
                Spacer()
                    .frame(height: 150)
                HStack(content: {
                    Text("할 일 : ")
                        .bold()
                    
                    TextField("", text: $title)
                        .padding()
                        .frame(width: 250)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.default)
                        .focused($isTextFieldFoucsed)
                        .disabled(status == 1 ? true : false)
                })
                .padding(.bottom, 50)
                
                HStack {
                    Spacer()
                    showDatePicker("시작일", variable: $startdate)
                        .disabled(status == 1 ? true : false)
                    Spacer()
                }
                .padding(.bottom, 10)
            
                HStack {
                    Spacer()
                    showDatePicker("종료일", variable: $enddate)
                        .disabled(status == 1 ? true : false)
                    Spacer()
                }
                .padding(.bottom, 60)
                

            VStack {
                if status == 1 {
                    Text("수정하기")
                        .foregroundStyle(Color.gray.opacity(0.5))
                } else {
                    Button("수정하기", action: {
                        isAlert.toggle()
                        isTextFieldFoucsed = false
                        
                        self.result = viewModel.update(id: id, title: title, startdate: startdate, enddate: enddate)
                        if self.result {
                            showAlert(title: "알림", message: "수정되었습니다.", button: "확인")
                        } else {
                            showAlert(title: "알림", message: "수정에 실패했습니다.", button: "확인")
                        }
                        isAlert = true
                    })
                    .tint(.white)
                    .disabled(status == 1)
                    .opacity(status == 1 ? 0.5 : 1.0)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .background(Color("myColor1"))
                    .cornerRadius(30)
                    .controlSize(.large)
                    .alert(isPresented: $isAlert, content: {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertMessage),
                            dismissButton: .default(Text(alertButton), action: {
                                // 알림 창을 닫는 액션을 여기에 추가합니다.
                                isAlert = false
                            })
                        )
                    })
                }
                //.frame(width: 200, height: 50)
                }
                
            }) //vstack
        } // scrollview
        .navigationTitle("할 일 수정")
        .navigationBarTitleDisplayMode(.large)
    } // body
    
    func showAlert(title: String, message: String, button: String) {
        alertTitle = title
        alertMessage = message
        alertButton = button
        isAlert = true
        dismiss()
    }
}

#Preview {
    TodoDetailPage(id: "sssss", title: "222", startdate: Date(), enddate: Date(), status: 0)

}
