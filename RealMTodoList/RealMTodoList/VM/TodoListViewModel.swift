
//  ViewModel.swift
//  RealMTodoList
//
//  Created by 신나라 on 5/22/24.


import Foundation
import RealmSwift

class TodoListViewModel: ObservableObject {
    
    @ObservedResults(TodoListObject.self) var todoLists
    @Published var todos: [TodoList] = []
    
    private var token: NotificationToken?
    
    init() {
        setupObserver()
    }
    
    deinit{
        token?.invalidate()
    }
    
    // select
    func setupObserver() {
        do {
            
            let realm = try Realm()
            let results = realm.objects(TodoListObject.self)
            print("direct : ",realm.configuration.fileURL!)
            
            token = results.observe({ changes in
                self.todos = results.map(TodoList.init)
                    .sorted(by: {$0.startdate > $1.startdate})
            })
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //add
    func addTodoList(title: String, startdate: Date, enddate: Date, status: Int) {
        let todolist = TodoListObject()
        todolist.title = title
        todolist.startdate = startdate
        todolist.enddate = enddate
        todolist.status = status
        $todoLists.append(todolist)
    }
    
    
    func update(id: String, title: String, startdate: Date, enddate: Date, status: Int) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: id)
            let todo = realm.object(ofType: TodoListObject.self, forPrimaryKey: objectId)
            try realm.write{
                todo?.title = title
                todo?.startdate = startdate
                todo?.enddate = enddate
                todo?.status = status
                
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //delete
    func deleteTodoList(id : String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: id)
            if let todo = realm.object(ofType: TodoListObject.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(todo)
                }
            }
        } catch let error {
            print(error)
        }
    }
}
