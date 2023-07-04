//
//  TaskHeaderTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 19/01/21.
//

import UIKit

class TaskHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var toggleArrowButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var linkButton: UIButton!
    @IBOutlet var reOrderButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var deleteButtonWConstraint: NSLayoutConstraint!
    @IBOutlet var deleteButtonLConstraint: NSLayoutConstraint!
    
    var displayMode:TaskInputDisplayType = .view
    var categoryId:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        
        self.mainView.backgroundColor = .white
        self.mainView.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        
        self.nameLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.nameLabel.textColor = .primaryColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
        
        self.toggleArrowButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon), for: .normal)
        self.toggleArrowButton.backgroundColor = .clear
        self.toggleArrowButton.tintColor = .customBlackColor()
        
        self.deleteButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.deleteIcon), for: .normal)
        self.deleteButton.backgroundColor = .clear
        self.deleteButton.tintColor = .customBlackColor()
        
        self.linkButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.linkIcon), for: .normal)
        self.linkButton.backgroundColor = .clear
        self.linkButton.tintColor = .customBlackColor()
        
        self.reOrderButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.reOrderIcon), for: .normal)
        self.reOrderButton.backgroundColor = .clear
        self.reOrderButton.tintColor = .customBlackColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.toggleArrowButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon), for: .normal)
    }
    
    func setContent(indexSection:Int, section:TaskTemplateStructure, target:TaskInputVC?){
        
        self.toggleArrowButton.addTarget(target, action: #selector(target?.toggleCollapse(_:)), for: .touchUpInside)
        self.toggleButton.addTarget(target, action: #selector(target?.toggleCollapse(_:)), for: .touchUpInside)
        self.toggleButton.tag = indexSection
        self.toggleArrowButton.tag = indexSection
        
        self.deleteButton.tag = indexSection
        self.deleteButton.addTarget(target, action: #selector(target?.categoryDeleteButtonTapped(_:)), for: .touchUpInside)
        self.linkButton.tag = indexSection
        self.linkButton.addTarget(target, action: #selector(target?.categoryLinkButtonTapped(_:)), for: .touchUpInside)
        self.reOrderButton.tag = indexSection
        self.reOrderButton.addTarget(target, action: #selector(target?.categoryTaskAlignmentButtonTapped(_:)), for: .touchUpInside)

        self.nameLabel.text = section.categoryTitle
        self.linkButton.isHidden = self.displayMode == .view ? true : false
        self.deleteButton.isHidden = self.displayMode == .add ? false : true
        self.deleteButtonWConstraint.constant = displayMode == .add ? 15.0 : 0.0
        self.deleteButtonLConstraint.constant = displayMode == .add ? 15.0 : 0.0
        self.reOrderButton.isHidden = self.displayMode == .view ? true : false
        
        if section.collapsed{
            self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
            self.toggleArrowButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.downArrowIcon), for: .normal)
        }else{
            self.toggleArrowButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.upArrowIcon), for: .normal)
            self.mainView.roundCorners(corners: [.topLeft,.topRight], radius: 8.0)
        }
    }
}
