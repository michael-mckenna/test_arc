//
//  CompletionDate.swift
//  ARC Decision Tool
//
//  Created by Michael McKenna on 4/8/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Required since we couldn't figure out how to perform a migration on the pre-bundled realm.

 Associates a `Task` with a date in which it was completed
 
 - TODO: add a `completedAt` variable to the `Task` model
*/
class CompletionDate: Object {
    @objc dynamic var taskId: String = ""
    @objc dynamic var completedAt: Date?
    
    convenience init(taskId: String) {
        self.init()
        self.completedAt = Date()
        self.taskId = taskId
    }
    override static func primaryKey() -> String? {
        return "taskId"
    }
}
