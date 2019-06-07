//
//  FirestoreReferenceManager.swift
//  ToDoAppDemo
//
//  Created by Shashank Panwar on 07/06/19.
//  Copyright © 2019 Shashank Panwar. All rights reserved.
//

import Foundation
import Firebase

struct FirestoreReferenceManager{
    static let db = Firestore.firestore()
    static let root = db.collection(environment.rawValue).document(environment.rawValue)
}
