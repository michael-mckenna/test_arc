//
//  CreateEventTableViewController.swift
//  ARC Decision Tool
//
//  Created by steven tran on 2/15/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

/// Contains logic for creating, updating, and deleting a `Hurricane`
class CreateEventTableViewController: UITableViewController {
    
    // MARK: - Actions
    
    /**
     Used to reset the hurricane database and input fields when a button is clicked
     
     - Parameter configuration: A button click on "End Tracking"
    */
    @IBAction func endTrackingTapped(_ sender: Any) {
        AlertControllers.finishAlert(self)
    }
    
    /**
     Used to create a hurricane object from the users inputs, and store the object in the realm database.
     Is used to check if there is an existing hurricane object and updates it. If not, it will create a new hurricane
     object. Also schedules notifications for each timeline using scheduleLocalNotifications() function in
     `TaskNotifications`.
     
     - Parameter configuration: A button click on "Save"
     */
    @IBAction func createEvent(_ sender: Any) {
        
        // checks if there is any empty fields in the user input and returns a message prompting the user to fill out the empty field
        guard !hasEmptyFields() else { return }
        
        // creating unamanged instance of the hurricane
        let hurricane = Hurricane(value: self.hurricane)
        
        var inputTasks : [Task] = []
        
        // creates a unique identifier for the hurricane object
        if hurricane.id.isEmpty {
            hurricane.id = UUID().uuidString
        }
        
        hurricane.name = hurricaneName.text!
        hurricane.location = location.text!
        hurricane.evacOrder = evacOrder.text!
        
        // formats arrivalTime into a date object
        if let landfall = dateFormatter.date(from: arrivalTime.text!) {
            hurricane.landfall = landfall
        }
        
        // formats leadTimeShelter into a date object
        if let leadTime = dateFormatter.date(from: leadTimeShelter.text!) {
            hurricane.leadTimeToOpenShelters = leadTime
            inputTasks.append(Task(completion: leadTime, name: "Lead Time to Open Shelters", landfall: hurricane.landfall))
        }
        
        // formats airportClose time into a date object
        if let airportCloseTime = dateFormatter.date(from: airportClose.text!) {
            hurricane.airportsCloseTime = airportCloseTime
            inputTasks.append(Task(completion: airportCloseTime, name: "Airport Close Times", landfall: hurricane.landfall))
        }
        
        // formats hunkerDown into a date object
        if let hunkerDown = dateFormatter.date(from: hunkerDown.text!) {
            hurricane.hunkerDownTime = hunkerDown
            inputTasks.append(Task(completion: hunkerDown, name: "Hunker Down Time", landfall: hurricane.landfall))
        }
        
        // formats reentryTime into a date object
        if let reEntry = dateFormatter.date(from: reentryTime.text!) {
            hurricane.expectedReEntryTime = reEntry
            inputTasks.append(Task(completion: reEntry, name: "Expected Re-Entry Time", landfall: hurricane.landfall))
        }
        
        let calendar = Calendar.current
        
        // REGION CALL TIMES
        // formats ccTimeRegion1 into a date object and creates the object for each timeline
        if let conferenceOne = timeFormatter.date(from: ccTimeRegion1.text!) {
            hurricane.conferenceCallTimeForRegion.append(conferenceOne)
            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: conferenceOne)
            
            for index in -4...2{
                
                if index == -2{
                    continue
                }
                
                var landfallDateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: hurricane.landfall.advanceBy(index))
                
                dateComponents?.year = landfallDateComponents?.year
                dateComponents?.month = landfallDateComponents?.month
                dateComponents?.day = landfallDateComponents?.day
                
                inputTasks.append(Task(completion: calendar.date(from: dateComponents!)!, name: "Region Conference Call 1", landfall: hurricane.landfall))
            }
        }
        
        // formats ccTimeRegion2 into a date object and creates the object for each timeline
        if let conferenceTwo = timeFormatter.date(from: ccTimeRegion2.text!) {
            hurricane.conferenceCallTimeForRegion.append(conferenceTwo)
            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: conferenceTwo)
            
            for index in -4...2{
                
                if index == -2{
                    continue
                }
                
                var landfallDateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: hurricane.landfall.advanceBy(index))
                
                dateComponents?.year = landfallDateComponents?.year
                dateComponents?.month = landfallDateComponents?.month
                dateComponents?.day = landfallDateComponents?.day
                
                inputTasks.append(Task(completion: calendar.date(from: dateComponents!)!, name: "Region Conference Call 2", landfall: hurricane.landfall))
            }
        }
        
        // NHQ CALL TIMES
        
        // formats ccTimeNHQ1 into a date object and creates the object for each timeline
        if let conferenceOne = timeFormatter.date(from: ccTimeNHQ1.text!) {
            hurricane.conferenceCallTimeForNHQ.append(conferenceOne)
            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: conferenceOne)
            
            for index in -4...2{
                
                if index == -2{
                    continue
                }
                
                var landfallDateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: hurricane.landfall.advanceBy(index))
                
                dateComponents?.year = landfallDateComponents?.year
                dateComponents?.month = landfallDateComponents?.month
                dateComponents?.day = landfallDateComponents?.day
                
                inputTasks.append(Task(completion: calendar.date(from: dateComponents!)!, name: "NHQ Conference Call 1", landfall: hurricane.landfall))
            }
        }
        
        // formats ccTimeNHQ2 into a date object and creates the object for each timeline
        if let conferenceTwo = timeFormatter.date(from: ccTimeNHQ2.text!) {
            hurricane.conferenceCallTimeForNHQ.append(conferenceTwo)
            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: conferenceTwo)
            
            for index in -4...2{
                
                if index == -2{
                    continue
                }
                
                var landfallDateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: hurricane.landfall.advanceBy(index))
                
                dateComponents?.year = landfallDateComponents?.year
                dateComponents?.month = landfallDateComponents?.month
                dateComponents?.day = landfallDateComponents?.day
                
                inputTasks.append(Task(completion: calendar.date(from: dateComponents!)!, name: "NHQ Conference Call 2", landfall: hurricane.landfall))
            }
        }
        
        var hurricaneExists = true
        
        // checks if there is an existing hurricane in the database
        if (realm.objects(Hurricane.self).count == 0){
            hurricaneExists = false
        }
        
        // updates the database
        try! realm.write {
            realm.add(hurricane, update: true)
        }
        
        // copy "parent" dataset of tasks into the local realm only upon creating a hurricane (at which point there will be no tasks in realm)
        if realm.objects(Task.self).count == 0 {
            let preBundled = try! Realm(configuration: RealmHelper.tasksConfig)
            let tasks = preBundled.objects(Task.self)
            for task in tasks {
                let unmanagedTask = Task(value: task)
                if unmanagedTask.timeline != "0"{
                    try! realm.write {
                        realm.add(unmanagedTask, update: true)
                    }
                }
            }
        }

        RealmHelper.setStaticTaskDates()
        
        if !hurricaneExists {
            for task in inputTasks {
                try! realm.write {
                    realm.add(task, update: true)
                }
            }
        }
        
        // if the user changed the landfall time, remove all scheduled notifications and reschedule new ones based on new time
        let beforeTime = checkLandFallChange.zeroSeconds!
        let afterTime = hurricane.landfall.zeroSeconds!
        if(beforeTime != afterTime){
            TaskNotifications.scheduleLocalNotifications()
            print("landfall date changed")
        }
        
        performSegue(withIdentifier: "toTasks", sender: nil)
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var hurricaneName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var arrivalTime: UITextField!
    @IBOutlet weak var evacOrder: UITextField!
    @IBOutlet weak var leadTimeShelter: UITextField!
    @IBOutlet weak var airportClose: UITextField!
    @IBOutlet weak var hunkerDown: UITextField!
    @IBOutlet weak var reentryTime: UITextField!
    @IBOutlet weak var ccTimeRegion1: UITextField!
    @IBOutlet weak var ccTimeRegion2: UITextField!
    @IBOutlet weak var ccTimeNHQ1: UITextField!
    @IBOutlet weak var ccTimeNHQ2: UITextField!
    @IBOutlet weak var endTrackingButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var hurricane = Hurricane()
    var activeTextField: UITextField!
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    var checkLandFallChange = Date()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the proper format to the corresponding date formatter
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        timeFormatter.dateFormat = "h:mm a"
        
        if hurricane.id.isEmpty {
            // hide end tracking button
            endTrackingButton.isEnabled = false
            endTrackingButton.title = nil
        } else {
            endTrackingButton.isEnabled = true
            endTrackingButton.title = "End Tracking"
            populateTextFields()
        }
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: .valueChanged)
        
        // setting input view to be the date picker for the appropriate views
        arrivalTime.inputView     = datePicker
        leadTimeShelter.inputView = datePicker
        airportClose.inputView    = datePicker
        hunkerDown.inputView      = datePicker
        reentryTime.inputView     = datePicker
        ccTimeRegion1.inputView   = datePicker
        ccTimeRegion2.inputView   = datePicker
        ccTimeNHQ1.inputView      = datePicker
        ccTimeNHQ2.inputView      = datePicker
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ensures all input fields are visible
        return (tableView.bounds.height - 60) / 12
    }
    
    // MARK: - Date Picker
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        if activeTextField.tag <= 7 {
            activeTextField.text = dateFormatter.string(from: sender.date)
        } else {
            activeTextField.text = timeFormatter.string(from: sender.date)
        }
    }
    
    // MARK: - Custom Methods
    
    /**
     used to check if any of the input fields are empty
     
     - returns: a boolean value
     */
    func hasEmptyFields() -> Bool {
        if
            hurricaneName.text!.isEmpty ||
            location.text!.isEmpty ||
            arrivalTime.text!.isEmpty  ||
            evacOrder.text!.isEmpty ||
            leadTimeShelter.text!.isEmpty ||
            airportClose.text!.isEmpty ||
            hunkerDown.text!.isEmpty ||
            reentryTime.text!.isEmpty ||
            ccTimeRegion1.text!.isEmpty ||
            ccTimeNHQ1.text!.isEmpty
        {
            AlertControllers.okAlert(self, title: "Error", message: "Please fill out empty fields")
            return true
        }
        
        return false
    }
    
    /**
     populates the input fields with data from the hurricane object
     */
    func populateTextFields() {
        checkLandFallChange = hurricane.landfall
        hurricaneName.text   = hurricane.name
        location.text        = hurricane.location
        arrivalTime.text     = dateFormatter.string(from: hurricane.landfall)
        evacOrder.text       = hurricane.evacOrder
        leadTimeShelter.text = dateFormatter.string(from: hurricane.leadTimeToOpenShelters)
        airportClose.text    = dateFormatter.string(from: hurricane.airportsCloseTime)
        hunkerDown.text      = dateFormatter.string(from: hurricane.hunkerDownTime)
        reentryTime.text     = dateFormatter.string(from: hurricane.expectedReEntryTime)
        
        for i in 0..<hurricane.conferenceCallTimeForRegion.count {
            switch i {
            case 0: ccTimeRegion1.text = timeFormatter.string(from: hurricane.conferenceCallTimeForRegion[0])
            case 1: ccTimeRegion2.text = timeFormatter.string(from: hurricane.conferenceCallTimeForRegion[1])
            default: break
            }
        }
        
        for i in 0..<hurricane.conferenceCallTimeForNHQ.count {
            switch i {
            case 0: ccTimeNHQ1.text = timeFormatter.string(from: hurricane.conferenceCallTimeForNHQ[0])
            case 1: ccTimeNHQ2.text = timeFormatter.string(from: hurricane.conferenceCallTimeForNHQ[1])
            default: break
            }
        }
    }
    
    /**
     clears all input fields to null
     */
    func clearTextFields() {
        hurricaneName.text  = ""
        location.text        = ""
        arrivalTime.text     = ""
        evacOrder.text       = ""
        leadTimeShelter.text = ""
        airportClose.text    = ""
        hunkerDown.text      = ""
        reentryTime.text = ""
        ccTimeRegion1.text     = ""
        ccTimeRegion2.text     = ""
        ccTimeNHQ1.text     = ""
        ccTimeNHQ2.text     = ""
    }
 }

extension CreateEventTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField.tag <= 7 {
            datePicker.datePickerMode = .dateAndTime
        } else {
            datePicker.datePickerMode = .time
        }
    }
}
