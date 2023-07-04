//
//  AddTaskTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class AddTaskTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var addTaskImageView:UIImageView!
    @IBOutlet var addTaskButton:UIButton!
    
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
        
        titleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "taskTitleText")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        
        self.addTaskImageView.image = Config.Images.shared.getImage(imageName: Config.Images.addTaskIcon)
        self.addTaskImageView.contentMode = .scaleAspectFit
        
        self.addTaskButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "addTaskText"), for: .normal)
        self.addTaskButton.backgroundColor = .clear
        self.addTaskButton.setTitleColor(.primaryColor(), for: .normal)
        self.addTaskButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
    }
    
    func setContet(model:TaskModel, target:OrderInfoVC?){
        self.addTaskButton.tag =  target?.taskModel.data.count == 0 ? target!.addTag : target!.viewTag
        self.addTaskButton.addTarget(target, action: #selector(target?.addOrViewTaskButtonTapped(_:)), for: .touchUpInside)
        
        self.addTaskButton.setTitle(self.addTaskButton.tag == 903 ? LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "addTaskText") : LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "viewTaskText"), for: .normal)
        self.mainView.isUserInteractionEnabled = model.isSectionEnabled
        self.mainView.layer.opacity = model.isSectionEnabled ? 1.0 : 0.3
    }
}
