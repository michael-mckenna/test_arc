//
//  TasksTableViewController.swift
//  ARC Decision Tool
//
//  Created by steven tran on 2/15/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

/// Contains logic for displaying tasks in each timeline
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Actions
    
    /**
     Used for reloading the timeline data when a new timeline is clicked
     
     - Parameter sender: A button click
     */
    @IBAction func changeTaskTimeline(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }

    // MARK: - Outlets
    
    @IBOutlet weak var timeTillLandfallLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    let realm = try! Realm()
    let hurricane = RealmHelper.getCurrentHurricane()
    var timer = Timer()
    var isTimerRunning = false
    var seconds = 0
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    var selectedTitle = "120"
    let cellIdentifiers:[String] = ["120","96","72-48","24","Landfall","Post-Landfall","Completed"]
    /*
     Key: Timeline (e.g. '120')
     Value: Array of Task objects
     */
    var taskDict: [String: Results<Task>] = RealmHelper.getTimelinesAsDict()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "d MMM yyyy h:mm a"
        timeFormatter.dateFormat = "h:mm a"
        title = hurricane.name
        seconds = Int(getTimeIntervalInSeconds())
        
        if isTimerRunning == false{
            runTimer()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TaskCell else {
            return UITableViewCell()
        }
        
        let key = getKey(from: selectedTitle)
        let tasks = taskDict[key]
        
        if let task = tasks?[indexPath.row] {
            if key == "Completed"{
                cell.taskTime.text = dateFormatter.string(from: realm.object(ofType: CompletionDate.self, forPrimaryKey: task.id)?.completedAt ?? Date())
            }else {
                cell.taskTime.text = timeString(time: task.completionDate.timeIntervalSince(Date()))
            }
            cell.taskName.text = task.name
            
            var hourWarningDate: DateComponents? = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: task.completionDate)
            let hour = hourWarningDate?.hour
            hourWarningDate?.hour = hour! - 1

            if !task.isCompleted && Calendar.current.date(from: hourWarningDate!)! <= Date() {
                cell.backgroundColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            } else if task.name == "Establish time period when all shelter residents and ARC workforce go into protected areas for X time period covering pre and post landfall hazards.  Time period is based on track and projections" || task.name == "Initiate EBV plan for VIC’s"{
                cell.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
            } else {
                cell.backgroundColor = task.isCompleted ? UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5) : UIColor.white
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskCell else { return }
        
        let key = getKey(from: selectedTitle)
        let tasks = taskDict[key]
        if let task = tasks?[indexPath.row] {
            AlertControllers.completeTaskAlert(self, cell: cell, task: task)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = getKey(from: selectedTitle)
        let tasks = taskDict[key]

        return tasks?.count ?? 0
    }
    
    // MARK: Custom Methods
    
    /**
     Used for getting corresponding key for a given timeline
     
     - Parameter title: The title of the timeline to get the key for
     - returns: A string as the key for getting a `taskDict` value
     */
    func getKey(from title: String) -> String {
        switch title {
        case "72-48": return "7248"
        case "Landfall":  return "0"
        case "Post-Landfall": return "-1"
        default: return title
        }
    }
    
    /**
     Used for getting the time interval in seconds between the current date and the landfall of the `Hurricane`
     
     - returns: A double representing the time between the current date and the landfall date
     */
    func getTimeIntervalInSeconds() -> Double {
        return hurricane.landfall.timeIntervalSince(Date())
    }
    
    /**
     Used for formatting a time to be displayed for each `Task`
     
     - Parameter time: a `TimeInterval`
     - returns: A string formatted to display the `TimeInterval` as "Time Left"
     */
    func timeString(time:TimeInterval) -> String {
        let days = Int(time) / (3600 * 24)
        let hours = Int(time) / 3600 % 24
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"Time left: %02id  %02ih  %02im  %02is", days, hours, minutes, seconds)
    }
    
    /**
     Used to schedule the timer for the countdown display at the top of the task view
     */
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
    }
    
    /**
     Used for updating the countdown timer at the top of the task view
     */
    @objc func updateTimer() {
        seconds -= 1
        timeTillLandfallLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CreateEventTableViewController {
            dest.hurricane = self.hurricane
        }
    }
}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTitle = cellIdentifiers[indexPath.row]
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifiers[indexPath.row], for: indexPath)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.backgroundColor = UIColor.red
        
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / (4.5)) + 24, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
}
