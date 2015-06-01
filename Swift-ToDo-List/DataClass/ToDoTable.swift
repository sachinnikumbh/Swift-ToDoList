//
//  ToDoTable.swift
//  Swift-ToDo-List
//
//  Created by Sachin Nikumbh on 28/05/15.
//  Copyright (c) 2015 SN. All rights reserved.
//

import Foundation
import CoreData

class ToDoTable: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var date: NSDate
    @NSManaged var time: String
    @NSManaged var ampm: String
    @NSManaged var alarm: NSNumber

}
