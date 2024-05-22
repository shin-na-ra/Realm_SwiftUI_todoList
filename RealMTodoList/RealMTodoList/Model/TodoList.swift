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
//    @Persisted var id: Int = 0
    @Persisted var image: String = ""
    @Persisted var todo: String = ""
    @Persisted var insertDate: Date = Date.now
    @Persisted var status: Int = 0
    @Persisted var seq: Int = 0
}


extension TodoList {
    
    // instance 하나 생성
    private static var realm = try! Realm()
    
    //realm에 담긴 값들을 Results<TodoList> 형태로 가져온다.
    static func queryAll() -> Results<TodoList> {
        realm.objects(TodoList.self)
    }
    
    //realm 객체에 값을 추가
    static func addQuery(_ todo: TodoList) {
        try! realm.write{
            realm.add(todo)
        }
    }
    
    //realm 객체의 값 삭제
    static func deleteQuery(_ todo: TodoList) {
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    //업데이트
    static func updateQuery(todolist: TodoList, todo: String, image: String) {
        try! realm.write {
            todolist.todo = todo
            todolist.image = image
        }
    }
}
