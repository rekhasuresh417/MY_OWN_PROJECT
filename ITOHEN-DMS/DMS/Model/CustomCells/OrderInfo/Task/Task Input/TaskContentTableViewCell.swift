//
//  TaskContentTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 19/01/21.
//

import UIKit

class TaskContentTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var addNewTaskButton: UIButton!
    @IBOutlet var addNewTaskButtonHConstraint: NSLayoutConstraint!
    
    var displayMode:TaskInputDisplayType = .view
    var addTaskHConstant:CGFloat = 30.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        self.mainView.backgroundColor = .white
        
        self.mainView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10.0)

        self.taskTableView.backgroundColor = .clear
        self.taskTableView.separatorStyle = .none
        
        self.addNewTaskButton.setTitle(LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "addNewTaskText"), for: .normal)
        self.addNewTaskButton.backgroundColor = .clear
        self.addNewTaskButton.setTitleColor(.primaryColor(), for: .normal)
        self.addNewTaskButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.addNewTaskButton.isHidden = true
        self.addNewTaskButtonHConstraint.constant = 0.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.taskTableView.dataSource = nil
        self.taskTableView.reloadInputViews()
        self.taskTableView.reloadData()
    }
    
    func setContent(indexSection:Int, target:TaskInputVC?){
        
        self.taskTableView.tag = indexSection
        self.taskTableView.dataSource = target
        self.taskTableView.delegate = target
        
        self.addNewTaskButton.tag = indexSection
        self.addNewTaskButton.addTarget(target, action: #selector(target?.addNewTaskButtonTapped(_:)), for: .touchUpInside)

        self.addNewTaskButton.isHidden = self.displayMode == .add ? false : true
        self.addNewTaskButtonHConstraint.constant = self.displayMode == .add ? self.addTaskHConstant : 0.0
    }
}
