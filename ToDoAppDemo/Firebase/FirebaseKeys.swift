//
//  FirebaseKeys.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 07/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import Foundation

struct FirebaseKeys{
    
    struct CollectionPath {
        static let tasks = "tasks"
    }
    
    struct DocumentKeys{
        static let taskTitle = "taskTitle"
        static let taskDescription = "taskDescription"
        static let taskDateTime = "taskDateTime"
        static let taskId = "taskId"
    }
}
