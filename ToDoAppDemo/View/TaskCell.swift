//
//  taskCell.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 06/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskDescLbl: UILabel!
    @IBOutlet weak var taskTitleLbl: UILabel!
    @IBOutlet weak var taskDateTimeLbl: UILabel!
    
    var task : Task?{
        didSet{
            
            taskTitleLbl.text = task?.taskTitle
            taskDescLbl.text = task?.taskDescription
        }
    }
    
}
