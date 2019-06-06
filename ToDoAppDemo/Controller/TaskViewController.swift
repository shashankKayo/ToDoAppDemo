//
//  TaskViewController.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 06/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    var selectedTask : Task?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var isTaskInfoUpdated = false
    private var isTaskInfoCompletedFilled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        setUpInitialUI()
        
    }
    
    func setUpInitialUI(){
        if let task = selectedTask{
            taskTitleTextField.text = task.taskTitle
            taskDescriptionTextView.text = task.taskDescription
        }
    }
    
    @IBAction func saveTaskBtnPressed(_ sender: UIButton) {
        
    }
    
    
    
}
