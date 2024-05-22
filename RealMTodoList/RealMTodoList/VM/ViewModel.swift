//
//  ViewModel.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var todoLists: [TodoList] = Array(TodoList.queryAll())
    func addModel(title: String, content: String, startdate: Date, enddate: Date, status: Int) -> Void {
        
        let todoList = TodoList(title: title, content: content, startdate: startdate, enddate: enddate, status: status)
        todoLists.append(todoList)
    }
        
    func refreshTodoList() -> Void {
        self.todoLists = Array(TodoList.queryAll())
    }
    
    func updateQuery(old: TodoList, title: String, content: String, startdate: Date, enddate: Date) -> Void {
        TodoList.updateQuery(todolist: old, title: title, content: content, startdate: startdate, enddate: enddate)
    }
}
