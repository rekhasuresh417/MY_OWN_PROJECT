//
//  TaskUpdateContentTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 20/01/21.
//

import UIKit

class TaskUpdateContentTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var taskTableView: UITableView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.mainView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8.0)

        self.taskTableView.backgroundColor = .clear
        self.taskTableView.separatorStyle = .none
        self.taskTableView.isScrollEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.taskTableView.dataSource = nil
        self.taskTableView.reloadInputViews()
        self.taskTableView.reloadData()
    }
    
    func setContent(indexSection:Int, target:TaskUpdateVC?){
        self.taskTableView.tag = indexSection
        self.taskTableView.dataSource = target
        self.taskTableView.delegate = target
    }
}
