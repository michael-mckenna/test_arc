//
//  AlertControllers.swift
//  ARC Decision Tool
//
//  Created by steven tran on 2/15/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//
import UIKit
import Foundation
import RealmSwift
import UserNotifications

/// Functions for various alerts based on the user's interaction with the application
class AlertControllers {
    /**
     A message that alerts the user of an error
     
     - Parameter controller: the presenting controller
     - Parameter title: string value of title of the alert controller
     - Parameter message: string value of the message component of the alert controller
     */
    static func okAlert(_ controller: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        }))
        controller.present(alertController, animated: true, completion:nil)
    }
    
    /**
     A message that alerts the user if they want to proceed with reseting the hurricane object
     
     - Parameter controller: the presenting controller
     */
    static func finishAlert(_ controller: CreateEventTableViewController) {
        let alertController = UIAlertController(title: "Confirmation", message: "Would you like to finish tracking tasks for this hurricane?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) -> Void in
        }))
        
        alertController.addAction(UIAlertAction(title: "YES", style: .destructive, handler: { (action) -> Void in
            // delete task objects in local relam
            try! controller.realm.write {
                controller.realm.delete(controller.realm.objects(Task.self))
                controller.realm.delete(controller.hurricane)
            }
    
            // reset controller
            controller.hurricane = Hurricane()
            controller.clearTextFields()
            controller.viewDidLoad()
            
            // deletes all notifcaitons from the old hurricane 
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }))
        
        controller.present(alertController, animated: true, completion:nil)
    }
    
    /**
     An message that alerts the user if they want to complete a certain task
     
     - Parameter configuration: the current view controller
     - Parameter cell: the tapped cell
     - Parameter task: the corresponding task object
     */
    static func completeTaskAlert(_ controller: ViewController, cell: TaskCell, task: Task) {
        let refreshAlert = UIAlertController(title: "Task Completion", message: "Task completed?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            //Working on updating the database
            try! controller.realm.write {
                task.isCompleted = true
                let completionDate = CompletionDate(taskId: task.id)
                
                controller.realm.add(task, update: true)
                controller.realm.add(completionDate, update: true)
            }
            controller.taskDict = RealmHelper.getTimelinesAsDict()
            
            controller.tableView.reloadData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
            if let completionDateObject = controller.realm.object(ofType: CompletionDate.self, forPrimaryKey: task.id) {
                try! controller.realm.write {
                    controller.realm.delete(completionDateObject)
                }
            }
            
            //Working on updating the database
            try! controller.realm.write {
                task.isCompleted = false
                controller.realm.add(task, update: true)
            }
            
            controller.tableView.reloadData()
        }))
        
        controller.present(refreshAlert, animated: true, completion: nil)
    }
}
