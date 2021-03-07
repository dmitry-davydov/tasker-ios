//
//  Task.swift
//  Tasker
//
//  Created by Дима Давыдов on 07.03.2021.
//

import Foundation

protocol TaskProtocol: class {
    var description: String {get set}
    
    func addSubtask(_ task: TaskProtocol)
    func cnt() -> Int
    subscript(index: Int) -> TaskProtocol? { get }
}

class Task: TaskProtocol {
    var description: String
    var childs: [TaskProtocol] = []
    
    required init(with description: String) {
        self.description = description
    }
    
    func addSubtask(_ task: TaskProtocol) {
        childs.append(task)
    }
    
    subscript(index: Int) -> TaskProtocol? {
        return childs[index]
    }
    
    func cnt() -> Int {
        return childs.count
    }
}
