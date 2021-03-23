//
//  TaskStorage.swift
//  Tasker
//
//  Created by Дима Давыдов on 07.03.2021.
//

import Foundation

class TaskStorage {
    
    static var shared = TaskStorage()
    private init(){}
    
    var tasks: [TaskProtocol] = []
    
    
}
