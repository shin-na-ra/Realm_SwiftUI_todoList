//
//  TodoList.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

import Foundation
import RealmSwift

class TodoListObject: Object, Identifiable {
    @Persisted(primaryKey : true) var id: ObjectId
    @Persisted var title: String
    @Persisted var startdate = Date()
    @Persisted var enddate = Date()
    @Persisted var status: Int
}


struct TodoList: Identifiable {
    var id: ObjectId
    var title: String
    var startdate: Date
    var enddate: Date
    var status: Int // 0: 진행중, 1: 완료
    
    init(todolist: TodoListObject) {
        self.id = todolist.id
        self.title = todolist.title
        self.startdate = todolist.startdate
        self.enddate = todolist.enddate
        self.status = todolist.status
    }
}

//struct TodoList {
//    var todolist: TodoListObject // Realm 모델 객체를 직접 사용
//    
//    init(todolist: TodoListObject) {
//        self.todolist = todolist
//    }
//}


//
//extension TodoList {
//    
//    // instance 하나 생성
//    private static var realm = try! Realm()
//    
//    // data select
//    static func queryAll() -> Results<TodoList> {
//        realm.objects(TodoList.self)
//    }
//    
//    //data add
//    static func addQuery(_ todo: TodoList) {
//        try! realm.write{
//            realm.add(todo)
//        }
//    }
//    
//    //data delete
//    static func deleteQuery(_ todo: TodoList) {
//        try! realm.write {
//            realm.delete(todo)
//        }
//    }
//    
//    //data update
//    static func updateQuery(todolist: TodoList, title: String, content: String, startdate: Date, enddate: Date ) {
//        try! realm.write {
//            todolist.title = title
//            todolist.content = content
//            todolist.startdate = startdate
//            todolist.enddate = enddate
//        }
//    }
//}
