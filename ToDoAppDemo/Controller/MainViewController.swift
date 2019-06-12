//
//  ViewController.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 06/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import UIKit
import CoreData
import Firebase

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
        attemptFetch()
        fetchDataFromFirestore()
    }
    
    /*
     Description : This function is used to download the content from datbase in local database if required.
     */
    func fetchDataFromFirestore(){
        FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.tasks).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let localData = self.controller.sections?.first?.objects{
                        if localData.isEmpty{
                            let taskDetailsDict = document.data()
                            let task = Task(context: context)
                            task.taskId = document.documentID
                            if let taskTitle = taskDetailsDict[FirebaseKeys.DocumentKeys.taskTitle] as? String{
                                task.taskTitle = taskTitle
                            }
                            if let taskDescription = taskDetailsDict[FirebaseKeys.DocumentKeys.taskDescription] as? String{
                                task.taskDescription = taskDescription
                            }
                            appDelegate.saveContext()
                        }else{
                            if let tasks = localData as? [Task]{
                                if !tasks.contains(where: {$0.taskId == document.documentID}){
                                    let taskDetailsDict = document.data()
                                    let task = Task(context: context)
                                    task.taskId = document.documentID
                                    if let taskTitle = taskDetailsDict[FirebaseKeys.DocumentKeys.taskTitle] as? String{
                                        task.taskTitle = taskTitle
                                    }
                                    if let taskDescription = taskDetailsDict[FirebaseKeys.DocumentKeys.taskDescription] as? String{
                                        task.taskDescription = taskDescription
                                    }
                                    appDelegate.saveContext()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /*
     Description: Function display the local datbase content 
     */
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objects = controller.fetchedObjects, objects.count > 0{
            let item = objects[indexPath.row]
            performSegue(withIdentifier: StoryboardId.mainVCToAddVCSegue, sender: item)
        }
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
        
        guard let _ = anObject as? Task else{
            print("an Object is not of type tasks")
            return
        }
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                print("Insertion takes place")
                taskTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                print("Deletion takes place")
                taskTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                print("Updation takes place")
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
