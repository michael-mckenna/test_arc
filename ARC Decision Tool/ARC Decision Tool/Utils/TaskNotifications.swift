//
//  TaskAlerts.swift
//  ARC Decision Tool
//
//  Created by Elliott Dobbs on 2/22/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift
import UserNotifications

enum Timeline: String {
    case timeline120 = "120"
    case timeline96 = "96"
    case timeline7248 = "7248"
    case timeline24 = "24"
    case timelineLandfall = "0"
    case timelinePostLandfall = "-1"
}

/// Functions for scheduling multiple and single notifications 
struct TaskNotifications {
    
    /**
     To be called after the hurricane is saved. Schedules an alert for each timeline
    */
    static func scheduleLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduleNotification(at: RealmHelper.getCurrentHurricane().landfall.advanceBy(-4), for: "120 Hour Timeline", completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
        scheduleNotification(at: RealmHelper.getCurrentHurricane().landfall.advanceBy(-3), for: "96 Hour Timeline", completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
        scheduleNotification(at: RealmHelper.getCurrentHurricane().landfall.advanceBy(-1), for: "48-72 Hour Timeline", completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
        scheduleNotification(at: RealmHelper.getCurrentHurricane().landfall, for: "24 Hour Timeline", completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
        scheduleNotification(at: RealmHelper.getCurrentHurricane().landfall.advanceBy(1), for: "Landfall Timeline", completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
        scheduleNotification(at: RealmHelper.getCurrentHurricane().landfall.advanceBy(2), for: "Post-Landfall Timeline", completion: { success in
            if success {
                print("Successfully scheduled notification")
            } else {
                print("Error scheduling notification")
            }
        })
    }
    
    /**
     Scheules a notification for a certain time given the date and name of the notification
     
     - Parameter configuration: a date object and name of the notification
     */
    static func scheduleNotification(at date: Date, for timeline: String, completion: @escaping (Bool) -> ()) {
        //create content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "\(timeline) ending", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification
        let calendar = Calendar.current
        var dateInfo = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date)
        dateInfo.hour = dateInfo.hour! - 1
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        let request = UNNotificationRequest(identifier: timeline, content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                // Handle any errors
                print(theError.localizedDescription)
            }
            
            completion(error == nil)
        }
    }
}






