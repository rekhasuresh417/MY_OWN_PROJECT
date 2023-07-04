//
//  TaskFieldsTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 19/01/21.
//

import UIKit
import MaterialComponents

class TaskFieldsTableViewCell: UITableViewCell {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerLabelView: UIView!
    @IBOutlet var headerDeleteView: UIView!
    @IBOutlet var headerEditView: UIView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var editImageView: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var deleteImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
//    @IBOutlet var placeHolderLabel1: UILabel!
//    @IBOutlet var placeHolderLabel2: UILabel!
    @IBOutlet var dateTextField: MDCOutlinedTextField!
    @IBOutlet var inChargeTextField: MDCOutlinedTextField!
    @IBOutlet var toggleArrowButton: UIButton!
    @IBOutlet var toggleCalenderButton: UIButton!
    @IBOutlet var mainView: UIView!
//    @IBOutlet var fieldView1: UIView!
//    @IBOutlet var fieldView2: UIView!
    @IBOutlet var headerEditViewWConstraint: NSLayoutConstraint!
    @IBOutlet var headerDeleteViewWConstraint: NSLayoutConstraint!
    
    var displayMode:TaskInputDisplayType = .view
    var categoryId:String = ""
    var taskId:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        self.mainView.backgroundColor = .white
        
        self.headerView.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
        
        self.nameLabel.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.backgroundColor = .clear
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        
        [headerLabelView,headerDeleteView,headerEditView].forEach { (view) in
            view?.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
        }
        
        editImageView.image = Config.Images.shared.getImage(imageName:  Config.Images.editIcon)
        deleteImageView.image = Config.Images.shared.getImage(imageName:  Config.Images.deleteIcon)
        
        [toggleArrowButton,toggleCalenderButton].forEach { (button) in
            button?.setBackgroundImage(Config.Images.shared.getImage(imageName: button == toggleArrowButton ? Config.Images.downArrowIcon : Config.Images.calenderIcon), for: .normal)
            button?.tintColor = button == toggleArrowButton ? .customBlackColor() : UIColor.init(rgb: 0x727272)
            button?.backgroundColor = .clear
        }
        
        [dateTextField,inChargeTextField].forEach { (textField) in
            textField?.textColor = .customBlackColor()
            textField?.textAlignment = .left
            textField?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        }

        //editButton.setImage(Config.Images.shared.getImage(imageName:  Config.Images.editIcon), for: .normal)
        self.editButton.tintColor = .customBlackColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
        self.dateTextField.text = ""
        self.inChargeTextField.text = ""
    }
    
    func setContent(target: TaskInputVC?, data:TaskTemplateStructureDatum){
       
        target?.setup(dateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "scheduleDatePlaceHolderText"))
        target?.setup(inChargeTextField, placeholderLabel: LocalizationManager.shared.localizedString(key1: "TaskInput", key2: "personInChargePlaceHolderText"))
        
        self.deleteButton.addTarget(target, action: #selector(target?.taskDeleteButtonTapped(_:)), for: .touchUpInside)
        self.editButton.addTarget(target, action: #selector(target?.taskEditButtonTapped(_:)), for: .touchUpInside)
        
        self.nameLabel.text = data.taskTitle
        self.dateTextField.text = data.taskScheduleDate
        self.inChargeTextField.text = target?.getContactNameForId(id: data.taskPic)
        
        self.inChargeTextField.delegate = target
        self.inChargeTextField.inputAccessoryView = target?.theToolbarForPicker
        self.inChargeTextField.inputView = target?.thePicker
        self.dateTextField.delegate = target
        self.dateTextField.inputAccessoryView = target?.theToolbarForDatePicker
        self.dateTextField.inputView = target?.theDatePicker
        
        self.dateTextField.isUserInteractionEnabled = displayMode == .view ? false : true
        self.inChargeTextField.isUserInteractionEnabled = displayMode == .view ? false : true
        
        self.headerDeleteView.alpha = displayMode == .add ? 1.0 : 0.0
        self.headerDeleteViewWConstraint.constant = displayMode == .add ? 30.0 : 0.0

        self.headerEditView.alpha = displayMode == .view ? 0.0 : 1.0
        self.headerEditViewWConstraint.constant = displayMode == .view ? 0.0 : 30.0
        
        self.toggleCalenderButton.alpha = displayMode == .view ? 0.0 : 1.0
        self.toggleArrowButton.alpha = displayMode == .view ? 0.0 : 1.0
    }
}
