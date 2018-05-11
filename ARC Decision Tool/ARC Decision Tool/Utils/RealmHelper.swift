//
//  RealmHelper.swift
//  ARC Decision Tool
//
//  Created by Elliott Dobbs on 2/22/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

/// Functions for handling information from the realm database 
class RealmHelper {
    
    static let tasksURL: URL = Bundle.main.url(forResource: "Tasks", withExtension: "realm")!
    static var tasksConfig: Realm.Configuration  {
        return Realm.Configuration(
            fileURL: tasksURL,
            readOnly: true,
            objectTypes: [Task.self, Hurricane.self])
    }
    
    /**
     Used for getting the current `Hurricane` object
     
     - returns: The current `Hurricane` object
     */
    static func getCurrentHurricane() -> Hurricane {
        let realm = try! Realm()
        return realm.objects(Hurricane.self).last!
    }
    
    /**
     Used for creating a dictionary where the key is the timeline and the value is list of `Task`s for the corresponding timeline
     
     - returns: A dictionary containing the `Task`s for each timeline
     */
    static func getTimelinesAsDict() -> [String: Results<Task>] {
        let realm = try! Realm()
        var dict: [String: Results<Task>] = [:]
    
        dict[Timeline.timeline120.rawValue]      = realm.objects(Task.self).filter("timeline == '\(Timeline.timeline120.rawValue)' AND isCompleted == false")
        dict[Timeline.timeline96.rawValue]       = realm.objects(Task.self).filter("timeline == '\(Timeline.timeline96.rawValue)' AND isCompleted == false")
        dict[Timeline.timeline7248.rawValue]     = realm.objects(Task.self).filter("timeline == '\(Timeline.timeline7248.rawValue)' AND isCompleted == false")
        dict[Timeline.timeline24.rawValue]       = realm.objects(Task.self).filter("timeline == '\(Timeline.timeline24.rawValue)' AND isCompleted == false")
        dict[Timeline.timelineLandfall.rawValue] = realm.objects(Task.self).filter("timeline == '\(Timeline.timelineLandfall.rawValue)' AND isCompleted == false")
        dict[Timeline.timelinePostLandfall.rawValue] = realm.objects(Task.self).filter("timeline == '\(Timeline.timelinePostLandfall.rawValue)' AND isCompleted == false")
        dict["Completed"] =  realm.objects(Task.self).filter("isCompleted == true")
        
        return dict
    }
    
    /**
     Used for getting which timeline a `Task` corresponds to based on it's date
     
     - Parameter date: The due date of the `Task` which needs a corresponding timeline
                 landfall: The landfall of the current `Hurricane`
     - returns: A string as the corresponding timeline to the date
     */
    static func setTimelineBasedOnDate(date: Date, landfall: Date) -> String{
        
        if (date < landfall.advanceBy(-4)){ //120
            return "120"
        }
        else if (date < landfall.advanceBy(-3)){ //96
            return "96"
        }
        else if (date < landfall.advanceBy(-1)){ //7248
            return "7248"
        }
        else if (date < landfall){ //24
            return "24"
        }
        else if (date < landfall.advanceBy(1)){ //landfall
            return "0"
        }
        else{//Post landfall
            return "-1"
        }
    }
    
    /**
     After setting the hurricane's landfall, this function is called to set the appropriate completion date for each task
    */
    static func setStaticTaskDates() {
        let realm = try! Realm()
        let hurricane = realm.objects(Hurricane.self).last!
        let landfall = hurricane.landfall
        
        
        let tasks = realm.objects(Task.self)
        for task in tasks {
            let timeline = task.timeline
            
            try! realm.write {
                switch timeline {
                case Timeline.timeline120.rawValue:
                    task.completionDate = landfall.advanceBy(-4)
                case Timeline.timeline96.rawValue:
                    task.completionDate = landfall.advanceBy(-3)
                case Timeline.timeline7248.rawValue:
                    task.completionDate = landfall.advanceBy(-1)
                case Timeline.timeline24.rawValue:
                    task.completionDate = landfall
                case Timeline.timelineLandfall.rawValue:
                    task.completionDate = landfall.advanceBy(1)
                case Timeline.timelinePostLandfall.rawValue:
                    task.completionDate = landfall.advanceBy(2)
                default:
                    break
                }
            }
        }
    }
}





