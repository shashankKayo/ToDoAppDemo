//
//  ViewController.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 06/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    struct StoryboardId{
        static let cellIdentifier = "cell"
        static let mainVCToAddVCSegue = "mainVCToAddVC"
    }

    @IBOutlet weak var taskTableView: UITableView!
    
    var taskModel = [Task]()
    var controller : NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generatedTestData()
        attemptFetch()
    }
    
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let titleSort = NSSortDescriptor(key: "taskTitle", ascending: true)
    
        fetchRequest.sortDescriptors = [titleSort]
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do{
            try controller.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func generatedTestData(){
        
        let task1 = Task(context: context)
        task1.taskTitle = "Swift Tutorial"
        task1.taskDescription = "Learning the latest version of swift because it released in the current WWDC. And the latest version of Xcode in 11 which is released now."
        taskModel.append(task1)
        
        let task2 = Task(context: context)
        task2.taskTitle = "Swift Tutorial"
        task2.taskDescription = "Learning the latest version of swift because it released in the current WWDC. And the latest version of Xcode in 11 which is released now."
         taskModel.append(task2)
        
        let task3 = Task(context: context)
        task3.taskTitle = "Swift Tutorial"
        task3.taskDescription = "Learning the latest version of swift because it released in the current WWDC. And the latest version of Xcode in 11 which is released now."
         taskModel.append(task3)
        
        let task4 = Task(context: context)
        task4.taskTitle = "Swift Tutorial"
        task4.taskDescription = "Learning the latest version of swift because it released in the current WWDC. And the latest version of Xcode in 11 which is released now."
        taskModel.append(task4)
        
        let task5 = Task(context: context)
        task5.taskTitle = "Swift Tutorial"
        task5.taskDescription = "Learning the latest version of swift because it released in the current WWDC. And the latest version of Xcode in 11 which is released now."
        taskModel.append(task5)
        
        let task6 = Task(context: context)
        task6.taskTitle = "Swift Tutorial"
        task6.taskDescription = "Learning the latest version of swift because it released in the current WWDC. And the latest version of Xcode in 11 which is released now."
        taskModel.append(task6)
        
        appDelegate.saveContext()
        
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: StoryboardId.mainVCToAddVCSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardId.mainVCToAddVCSegue{
            if let destination = segue.destination as? TaskViewController{
                if let task = sender as? Task{
                    destination.selectedTask = task
                }
            }
        }
    }
}

extension MainViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardId.cellIdentifier, for: indexPath) as? TaskCell{
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func configureCell(cell : TaskCell, indexPath : IndexPath){
        let item = controller.object(at: indexPath)
        cell.task = item
    }
    
}

extension MainViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}


extension MainViewController : NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                taskTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                taskTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                if let cell = taskTableView.cellForRow(at: indexPath) as? TaskCell{
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        case .move:
            if let indexPath = indexPath{
                taskTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                taskTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        @unknown default:
            print("Default case")
        }
    }
}
