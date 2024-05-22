//
//  TodoList.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.
//

// Realm에 저장할 데이터 객체를 정의
import Foundation
import RealmSwift

// 데이터 클래스 정의
class TodoList: Object {
    @Persisted var title: String = ""
    @Persisted var content: String = ""
    @Persisted var startdate: Date = Date.now
    @Persisted var enddate: Date = Date.now
    @Persisted var status: Int = 0 //0 : 진행중, 1: 완료
    
    init(title: String, content: String, startdate: Date, enddate: Date, status: Int) {
        self.title = title
        self.content = content
        self.startdate = startdate
        self.enddate = enddate
        self.status = status
    }
}


extension TodoList {
    
    // instance 하나 생성
    private static var realm = try! Realm()
    
    // data select
    static func queryAll() -> Results<TodoList> {
        realm.objects(TodoList.self)
    }
    
    //data add
    static func addQuery(_ todo: TodoList) {
        try! realm.write{
            realm.add(todo)
        }
    }
    
    //data delete
    static func deleteQuery(_ todo: TodoList) {
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    //data update
    static func updateQuery(todolist: TodoList, title: String, content: String, startdate: Date, enddate: Date ) {
        try! realm.write {
            todolist.title = title
            todolist.content = content
            todolist.startdate = startdate
            todolist.enddate = enddate
        }
    }
}
