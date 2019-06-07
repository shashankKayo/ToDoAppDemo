//
//  TaskViewController.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 06/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import UIKit
import Firebase

struct TaskDetail{
    var taskId : String?
    var taskName : String?
    var taskDescription : String?
    var taskDateTime : Date?
}

class TaskViewController: UIViewController {
    
    struct Constants{
        static let textViewPlaceholder = "Task Description"
    }
    
    var selectedTask : Task?
    var taskDetail : TaskDetail?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    private var isTaskInfoUpdated = false
    private var isTaskInfoCompletedFilled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        setUpInitialUI()
        
    }
    
    func setUpInitialUI(){
        taskTitleTextField.delegate = self
        taskDescriptionTextView.delegate = self
        if let task = selectedTask{
            deleteBarButton.isEnabled = true
            taskTitleTextField.text = task.taskTitle
            taskDescriptionTextView.text = task.taskDescription
        }else{
            deleteBarButton.isEnabled = false
            taskDescriptionTextView.text = Constants.textViewPlaceholder
            taskDescriptionTextView.textColor = .darkGray
        }
    }
    
    @IBAction func saveTaskBtnPressed(_ sender: UIButton) {
        view.endEditing(true)
        guard let taskTitle = taskTitleTextField.text?.trimmingCharacters(in: .whitespaces) else {return}
        let taskDescription = taskDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        taskDetail = TaskDetail(taskId: nil, taskName: taskTitle, taskDescription: taskDescription, taskDateTime: nil)
        
        if isRequiredFieldFilled(){
            if selectedTask == nil{
                let taskId = FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.tasks).document().documentID
                selectedTask = Task(context: context)
                selectedTask?.taskId = taskId
            }
            selectedTask?.taskTitle = taskDetail?.taskName!
            selectedTask?.taskDescription = taskDetail?.taskDescription!
            appDelegate.saveContext()
            updateDataIntoFirestore(task: selectedTask!)
            print("Successfully saved on local database.")
//
        }else{
            print("Some Error while Saving Data")
        }
    }
    
    @IBAction func deleteTaskBarButtonAction(_ sender: UIBarButtonItem) {
        if let item = selectedTask{
//            context.delete(item)
//            appDelegate.saveContext()
            deleteDataFromFirestore(task: item)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func isRequiredFieldFilled() -> Bool{
        guard let selectedTask = taskDetail else {return false}
        guard let _ = selectedTask.taskName else {
            print("No Task title entered")
            return false
        }
        guard let taskDescription = selectedTask.taskDescription  else{
            print("No Task Description entered")
            return false
        }
        if taskDescription == Constants.textViewPlaceholder{
             print("No Task Description entered")
            return false
        }
        return true
    }
    
    func updateDataIntoFirestore(task : Task){
        FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.tasks).document(task.taskId!)
            .setData([FirebaseKeys.DocumentKeys.taskId: task.taskId!,
                      FirebaseKeys.DocumentKeys.taskTitle : task.taskTitle!,
                      FirebaseKeys.DocumentKeys.taskDescription : task.taskDescription!], merge: true) { [weak self](error) in
                        guard let this = self else {return}
                        if let err = error{
                            print("Error : \(err.localizedDescription)")
                        }else{
                            print("Document Successfully Updated")
                            _ = this.navigationController?.popViewController(animated: true)
                        }
        }
    }
    
    func deleteDataFromFirestore(task : Task){
        FirestoreReferenceManager.root.collection(FirebaseKeys.CollectionPath.tasks).document(task.taskId!).delete { [weak self](error) in
            guard let this = self else {return}
            if let err = error{
                print("Error : \(err.localizedDescription)")
            }else{
                context.delete(task)
                appDelegate.saveContext()
                print("Document Successfully Deleted From Firebase")
                _ = this.navigationController?.popViewController(animated: true)
            }
        }
    }

}

extension TaskViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let taskDescription = taskDescriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if taskDescription.isEmpty{
            textView.text = Constants.textViewPlaceholder
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
}


extension TaskViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
