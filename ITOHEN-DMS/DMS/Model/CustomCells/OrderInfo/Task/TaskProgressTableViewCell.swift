//
//  TaskProgressTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 21/01/21.
//

import UIKit

class TaskProgressTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var taskTableView:UITableView!
    @IBOutlet var taskTableViewHConstraint: NSLayoutConstraint!
    @IBOutlet var viewTasksButton:UIButton!
    @IBOutlet var editButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        
        self.mainView.backgroundColor = .white
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.mainView.layer.shadowRadius = 3.0
        self.mainView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.mainView.layer.masksToBounds = false
        self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
        
        titleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "taskProgressText")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        
        self.taskTableView.backgroundColor = .clear
        self.taskTableView.separatorStyle = .none
        
        self.viewTasksButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "viewTaskText"), for: .normal)
        self.viewTasksButton.backgroundColor = .clear
        self.viewTasksButton.setTitleColor(.primaryColor(), for: .normal)
        self.viewTasksButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        
        self.editButton.isHidden = false
        self.editButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.editInfoIcon), for: .normal)
        self.editButton.backgroundColor = .clear
        self.editButton.tintColor = .primaryColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.taskTableView.dataSource = nil
        self.taskTableView.reloadInputViews()
        self.taskTableView.reloadData()
    }
    
    func setContent(target:OrderInfoVC?){
        self.viewTasksButton.tag = target!.viewTag
        self.viewTasksButton.addTarget(target, action: #selector(target?.addOrViewTaskButtonTapped(_:)), for: .touchUpInside)
        self.editButton.addTarget(target, action: #selector(target?.editTaskButtonButtonTapped(_:)), for: .touchUpInside)
        self.taskTableView.dataSource = target
        self.taskTableView.delegate = target
    }
}
