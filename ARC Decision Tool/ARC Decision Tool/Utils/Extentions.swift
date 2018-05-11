//
//  Extentions.swift
//  ARC Decision Tool
//
//  Created by Elliott Dobbs on 2/22/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

/// Adds functionality to the Date type
extension Date {
    /**
     Advances the date by the specified number of days
     */
    func advanceBy(_ value: Int) -> Date {
        
        let day = self
        if let next = (Calendar.current as NSCalendar).date(byAdding: .day, value: value, to: day, options: NSCalendar.Options(rawValue: 0)) {
            return next
        }
        
        return Date()
    }
    
    /**
     Set the second timer to zero in the date object 
     */
    var zeroSeconds: Date? {
        get {
            let calender = Calendar.current
            let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return calender.date(from: dateComponents)
        }
    }
}
