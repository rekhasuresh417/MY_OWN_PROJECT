//
//  TaskUpdateHeaderTableViewCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class TaskUpdateHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var toggleArrowButton: UIButton!
    @IBOutlet var mainView: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        
        self.mainView.backgroundColor = .white
        self.mainView.roundCorners(corners: [.topLeft,.topRight], radius: 5.0)
        
        self.nameLabel.font = UIFont.appFont(ofSize: 16.0, weight: .bold)
        self.nameLabel.textColor = .primaryColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
        
        self.toggleArrowButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon), for: .normal)
        self.toggleArrowButton.backgroundColor = .clear
        self.toggleArrowButton.tintColor = .customBlackColor()
        self.toggleArrowButton.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.toggleArrowButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon), for: .normal)
    }
    
    func setContent(indexSection: Int, section: EditTaskTemplateData, target: TaskUpdateVC?){
        
        self.toggleButton.addTarget(target, action: #selector(target?.toggleCollapse(_:)), for: .touchUpInside)
        self.toggleButton.tag = indexSection
        self.toggleArrowButton.tag = indexSection
        
        self.nameLabel.text = section.task_title
        
        if section.collapsed ?? false{
            self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
            self.toggleArrowButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.downArrowIcon), for: .normal)
        }else{
            self.toggleArrowButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon), for: .normal)
            self.mainView.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        }
    }
}
