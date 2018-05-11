//
//  Task.swift
//  ARC Decision Tool
//
//  Created by Michael McKenna on 2/20/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

/// An object managed by `Realm` representing a `Task` which belongs in a timeline
class Task: Object {
    /// String: uuid of the `Task`
    @objc dynamic var id: String = ""
    /// String: Name of the `Task`
    @objc dynamic var name: String = ""
    /// Date: Completion date of the `Task`
    @objc dynamic var completionDate: Date = Date()
    /// String: Which timeline the `Task` belongs to.  Can be 120, 96, 7248, 24, 0 (for landfall), -1 (for post-landfall)
    @objc dynamic var timeline: String = ""
    /// Boolean: If the `Task` is completed or not
    @objc dynamic var isCompleted: Bool = false
    
    convenience init(completion: Date, name: String, landfall: Date) {
        self.init()
        self.completionDate = completion
        self.name = name
        self.id = UUID().uuidString
        self.timeline = RealmHelper.setTimelineBasedOnDate(date: completion, landfall: landfall)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
