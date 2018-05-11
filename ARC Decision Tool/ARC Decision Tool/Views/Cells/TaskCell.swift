//
//  TaskCell.swift
//  ARC Decision Tool
//
//  Created by Elliott Dobbs on 2/27/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//
import UIKit
/// The cell object used to display a task in the table view 
class TaskCell: UITableViewCell {
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = UIColor.white
    }
    
}
