//
//  TaskUpdateFieldsTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 20/01/21.
//

import UIKit
import MaterialComponents

class TaskUpdateFieldsTableViewCell: UITableViewCell {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerLabelView: UIView!
    @IBOutlet var headerHistoryView: UIView!
    @IBOutlet var headerEditView: UIView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var historyLabel: UILabel!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var historyImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var placeHolderLabel1: UILabel!
//    @IBOutlet var placeHolderLabel2: UILabel!
    @IBOutlet var schduleDateTextField: UITextField!
    @IBOutlet var accompalishDateTextField: MDCOutlinedTextField!
    @IBOutlet var toggleCalenderButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet var fieldView1: UIView!
    @IBOutlet var fieldView2: UIView!
    @IBOutlet var fieldView3: UIView!
    @IBOutlet var scheduleNowButton: UIButton!
    @IBOutlet var taskNotScheduledLabel: UILabel!
    @IBOutlet var headerHistoryViewWConstraint: NSLayoutConstraint!
    @IBOutlet var headerEditViewWConstraint: NSLayoutConstraint!
    
    var categoryId:String = ""
    var taskId:String = ""
    var taskUpdateCellData: TaskTemplateStructureDatum?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = .none
        self.mainView.backgroundColor = .white
        self.headerView.backgroundColor = .clear
        
        self.nameLabel.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
        self.nameLabel.textColor = .customBlackColor()
        self.nameLabel.backgroundColor = .clear
        self.nameLabel.textAlignment = .left
        self.nameLabel.numberOfLines = 1
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.sizeToFit()
        
        self.placeHolderLabel1.font = UIFont.appFont(ofSize: 13.0, weight: .medium)
        self.placeHolderLabel1.textColor = .lightGray
        self.placeHolderLabel1.backgroundColor = .clear
        self.placeHolderLabel1.textAlignment = .left
        self.placeHolderLabel1.numberOfLines = 1
        self.placeHolderLabel1.adjustsFontSizeToFitWidth = true
        self.placeHolderLabel1.sizeToFit()
        
        [headerLabelView,headerHistoryView,headerEditView].forEach { (view) in
            view?.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
        }
      
        taskNotScheduledLabel.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        taskNotScheduledLabel.textColor = .gray
        taskNotScheduledLabel.textAlignment = .center
        taskNotScheduledLabel.numberOfLines = 0
        taskNotScheduledLabel.text =  LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "taskNotScheduledText")
        self.fieldView3.isHidden = true
        
        self.scheduleNowButton.setTitle(LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "scheduledNowButtonText"), for: .normal)
        self.scheduleNowButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.scheduleNowButton.setTitleColor(.primaryColor(), for: .normal)
        self.scheduleNowButton.contentHorizontalAlignment = .center
        self.scheduleNowButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.scheduleNowButton.layer.cornerRadius = self.scheduleNowButton.frame.height/2
        self.scheduleNowButton.backgroundColor = .clear
        
        historyLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        historyLabel.textColor = .customBlackColor()
        historyLabel.textAlignment = .right
        historyLabel.numberOfLines = 1
        historyLabel.sizeToFit()
        historyLabel.text =  LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "historyButtonText")
        placeHolderLabel1.text = LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "scheduleDatePlaceHolderText")
        
        historyImageView.image = Config.Images.shared.getImage(imageName:  Config.Images.historyIcon)
        editButton.setImage(Config.Images.shared.getImage(imageName:  Config.Images.editIcon), for: .normal)
        editButton.tintColor = .customBlackColor()
        
        [toggleCalenderButton].forEach { (button) in
            button?.setBackgroundImage(Config.Images.shared.getImage(imageName:  Config.Images.calenderIcon), for: .normal)
            button?.tintColor = UIColor.init(rgb: 0x727272)
            button?.backgroundColor = .clear
        }
        
        [schduleDateTextField,accompalishDateTextField].forEach { (textField) in
            textField?.textColor = .customBlackColor()
            textField?.textAlignment = .left
            textField?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        }
                
    }                                      
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
    }
    
    func setContent(target: TaskUpdateVC?, data:TaskTemplateStructureDatum){
   
        taskUpdateCellData = data
        target?.setup(accompalishDateTextField, placeholderLabel: LocalizationManager.shared.localizedString(key1: "TaskUpdate", key2: "accomplishedDatePlaceHolderText"))
        
        self.nameLabel.text = data.taskTitle
        self.schduleDateTextField.text = data.taskScheduleDate
        self.schduleDateTextField.isUserInteractionEnabled = false
        
        if self.schduleDateTextField.text == ""{
            self.fieldView1.isHidden = true
            self.fieldView2.isHidden = true
            self.fieldView3.isHidden = false
        }else{
            self.fieldView1.isHidden = false
            self.fieldView2.isHidden = false
            self.fieldView3.isHidden = true
        }
        
        self.accompalishDateTextField.text = data.taskAccomplishedDate
        self.accompalishDateTextField.delegate = target
        self.accompalishDateTextField.inputAccessoryView = target?.theToolbarForDatePicker
        self.accompalishDateTextField.inputView = target?.theDatePicker
        
        self.editButton.addTarget(target, action: #selector(target?.taskEditButtonTapped(_:)), for: .touchUpInside)
        self.historyButton.addTarget(target, action: #selector(target?.taskHistoryButtonTapped(_:)), for: .touchUpInside)
        self.scheduleNowButton.addTarget(target, action: #selector(target?.taskScheduleButtonTapped(_:)), for: .touchUpInside)
        
        self.headerHistoryView.alpha = data.rescheduled == "1" ? 1.0 : 0.0
        self.headerHistoryViewWConstraint.constant = data.rescheduled == "1" ? 100.0 : 0.0
       
        if  data.taskAccomplishedDate.count == 0{
            self.headerEditViewWConstraint.constant = 30.0
            self.headerEditView.isHidden = false
        }else{
            self.headerEditViewWConstraint.constant = 0.0
            self.headerEditView.isHidden = true
        }
    
    }
   
    

}
