//
//  TaskTableViewController.swift
//  Tasker
//
//  Created by Дима Давыдов on 07.03.2021.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    // задача, к которой будут созданы подзадачи
    // если nil то это контроллер для главного экрана
    var task: TaskProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let task = task {
            return task.cnt()
        }
        
        return TaskStorage.shared.tasks.count
    }
    
    private func cellData(indexPath: IndexPath) -> TaskProtocol? {
        if let task = task {
            return task[indexPath.row]
        }
        
        return TaskStorage.shared.tasks[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identity, for: indexPath) as? TaskCell else {
            fatalError("Can not dequeue cell for identity: \(TaskCell.identity)")
        }
        
        guard let data = cellData(indexPath: indexPath) else {
            fatalError("Can not get data for cell with indexPath: \(indexPath)")
        }
        
        cell.detailLabel.text = "\(data.cnt())"
        cell.titleLabel.text = data.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = cellData(indexPath: indexPath) else {
            tableView.deleteRows(at: [indexPath], with: .automatic)
            return
        }
        
        // переход на задачу
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TaskTableViewController") as TaskTableViewController
        
        vc.task = data
        vc.title = data.description
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Создает задачу
    // если task не nil, то создаем подзадачу
    @IBAction func addTask(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Новая задача", message: nil, preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: nil)
        
        let submitAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] (action) in
            
            guard let self = self,
                  let taskDescription = alertVC.textFields?[0].text else {return}
            
            let taskModel = Task(with: taskDescription)
           
            defer {
                self.tableView.reloadData()
            }
            
            if let task = self.task {
                task.addSubtask(taskModel)
                
                return
            }
            
            TaskStorage.shared.tasks.append(taskModel)
        }
        
        alertVC.addAction(submitAction)
        
        present(alertVC, animated: true, completion: nil)
    }
}
