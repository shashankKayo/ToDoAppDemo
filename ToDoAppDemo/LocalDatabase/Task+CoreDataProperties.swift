//
//  Task+CoreDataProperties.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 06/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskDate: NSDate?

}
