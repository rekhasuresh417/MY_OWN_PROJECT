//
//  TaskTemplateTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 19/01/21.
//

import UIKit
import MaterialComponents

class TaskTemplateTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
 //   @IBOutlet var placeHolderLabel: UILabel!
    @IBOutlet var templateTextField: MDCOutlinedTextField!
    @IBOutlet var toggleArrowButton: UIButton!
    @IBOutlet var readMoreButton: UIButton!
    @IBOutlet var mainView: UIView!
//    @IBOutlet var fieldView: UIView!
    
    var displayMode:TaskInputDisplayType = .view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.mainView.layer.shadowRadius = 5.0
        self.mainView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.mainView.layer.masksToBounds = false
  
        self.nameLabel.text = LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "templateText")
        self.nameLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.sizeToFit()
     
        self.templateTextField.textColor = .customBlackColor()
        self.templateTextField.textAlignment = .left
        self.templateTextField.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        
        self.toggleArrowButton.setBackgroundImage(Config.Images.shared.getImage(imageName: Config.Images.downArrowIcon), for: .normal)
        self.toggleArrowButton.backgroundColor = .clear
        self.toggleArrowButton.tintColor = .customBlackColor()
        
        self.readMoreButton.setTitle(LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "templateReadMoreText"), for: .normal)
        self.readMoreButton.backgroundColor = .clear
        self.readMoreButton.setTitleColor(UIColor.init(rgb: 0xFF4B1D), for: .normal)
    }
    
    func setContent(target:TaskInputVC?){
        
        // Common updates
        self.templateTextField.text = target?.getTemplateNameById()
        
        // Update ui based on display mode
        self.toggleArrowButton.alpha = self.displayMode == .add ? 1.0 : 0.0
        
        if self.displayMode == .add{
            target?.setup(templateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "templatePlaceHolderText"))
        }else{
                target?.setup(templateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "currentTemplatePlaceHolderText"))
        }
    
        if self.displayMode == .add{
            self.templateTextField.delegate = target
            self.templateTextField.delegate = target
            self.templateTextField.inputAccessoryView = target?.theTemplateToolbarForPicker
            self.templateTextField.inputView = target?.theTemplatePicker
        }else{
            self.templateTextField.isUserInteractionEnabled = false
        }
    }
}
