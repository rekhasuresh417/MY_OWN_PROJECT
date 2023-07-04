//
//  InquiryStatusTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 28/01/23.
//

import UIKit

class InquiryStatusTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var inquiryNoTitleLabel: UILabel!
    @IBOutlet var inquiryDateTitleLabel: UILabel!
    @IBOutlet var inquiryNoLabel: UILabel!
    @IBOutlet var inquiryDateLabel: UILabel!
    @IBOutlet var styleNoTitleLabel: UILabel!
    @IBOutlet var styleNoLabel: UILabel!
    @IBOutlet var itemNameTitleLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var dueDateTitleLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var inquiryFromTitleLabel: UILabel!
    @IBOutlet var inquiryFromLabel: UILabel!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    @IBOutlet var notificationDotImageView: UIImageView!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var centerArrowImageView: UIImageView!
    @IBOutlet var viewQuoteButton: UIButton!
    @IBOutlet var inquiryStatusLabel: UILabel!
    
    var inquiryId: String?
    var isPending: Bool = false
    var data: FactoryInquiryResponseData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    
        //self.mainView.applyLightShadow()
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        self.mainView.layer.borderWidth = 0.2
        self.mainView.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        
        self.bottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius:8)
        self.view1.roundCorners(corners: [.topLeft, .topRight], radius:8)
        self.view4.roundCorners(corners: [.bottomLeft, .bottomRight], radius:8)
        
        self.inquiryNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryNoText")
        self.inquiryDateTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryDateText")
        self.styleNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "styleNoText")
        self.itemNameTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "itemNameText"))"
        self.inquiryFromTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "inquiryFromText"))"
        self.dueDateTitleLabel.text = LocalizationManager.shared.localizedString(key: "dueDateText")
    
        [inquiryNoTitleLabel, inquiryDateTitleLabel, styleNoTitleLabel, dueDateTitleLabel, itemNameTitleLabel, inquiryFromTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [inquiryNoLabel, inquiryDateLabel, styleNoLabel, dueDateLabel, itemNameLabel, inquiryFromLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
            theLabel?.textColor = .gray
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
        viewQuoteButton.setTitle("", for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.inquiryNoLabel.text = ""
        self.inquiryDateLabel.text = ""
        self.styleNoLabel.text = ""
        self.itemNameLabel.text = ""
    }
    
    func setContent(data: FactoryInquiryResponseData, response: [Int], target: InquiryStatusVC?){
        
        self.data = data
        self.inquiryId = "\(data.id ?? 0)"
        self.inquiryNoLabel.text = "IN-\(data.id ?? 0)"
        self.inquiryDateLabel.text = DateTime.convertDateFormater("\(data.created_date ?? "")",
                                                                  currentFormat: Date.simpleDateFormat,
                                                                  newFormat: RMConfiguration.shared.dateFormat)
        self.styleNoLabel.text = data.style_no
        self.itemNameLabel.text = data.name
        self.inquiryFromLabel.text = data.user
        self.dueDateLabel.text = DateTime.convertDateFormater("\(data.due_date ?? "")",
                                                              currentFormat: Date.simpleDateFormat,
                                                              newFormat: RMConfiguration.shared.dateFormat)
        
        let dueDays = Int(abs(data.due_days ?? 0))
        var dueDate = Date()
        var responseDate = Date()
      
        if let dueDt = data.due_date, let responseDt = data.response_date{
            dueDate = DateTime.stringToDatetaskUpdate(dateString: dueDt, dateFormat: Date.simpleDateFormat) ?? Date()
            responseDate = DateTime.stringToDatetaskUpdate(dateString: responseDt, dateFormat: Date.simpleDateFormat) ?? Date()
            
            print(dueDate, responseDate)
        }
        
        if dueDate >= responseDate && response.contains(data.id ?? 0)  { //Quotation sent
            self.inquiryStatusLabel.text = LocalizationManager.shared.localizedString(key: "quoteSentText")
            self.changeColor(color: .primaryColor())
            self.statusImageView.image = Config.Images.shared.getImage(imageName: Config.Images.remindIcon)
        }else if dueDate < responseDate && response.contains(data.id ?? 0) { // Delayed completion
            self.inquiryStatusLabel.text = "\(LocalizationManager.shared.localizedString(key: "quoteSentText"))"
            self.changeColor(color: .delyCompletionColor())
            self.statusImageView.image = Config.Images.shared.getImage(imageName: Config.Images.remindIcon)
        }else if let dueDay = data.due_days, dueDay == 0{ // Not yet completed
            self.inquiryStatusLabel.text = LocalizationManager.shared.localizedString(key: "dueTodayText")
            self.changeColor(color: UIColor(rgb: 0x7C7C7C))
            self.statusImageView.image = Config.Images.shared.getImage(imageName: Config.Images.attnIcon)
        }else if data.due_days?.sign == .minus{ // Delayed
            self.inquiryStatusLabel.text = dueDays == 1 ? "\(dueDays) \(LocalizationManager.shared.localizedString(key: "dayDelayText"))" : "\(dueDays) \(LocalizationManager.shared.localizedString(key: "daysDelayText"))"
            self.statusImageView.image = Config.Images.shared.getImage(imageName: Config.Images.overdelayIcon)
            self.changeColor(color: .delayedColor())
        }else if data.due_days?.sign == .plus{ // Not yet completed
            self.inquiryStatusLabel.text = dueDays == 1 ? "\(dueDays) \(LocalizationManager.shared.localizedString(key: "dayRemainingText"))" : "\(dueDays) \(LocalizationManager.shared.localizedString(key: "daysRemainingText"))"
            self.statusImageView.image = Config.Images.shared.getImage(imageName: dueDays == 1 ? Config.Images.attnIcon : Config.Images.remindIcon)
            self.changeColor(color: UIColor(rgb: 0x7C7C7C))
        }
        
        self.mainView.backgroundColor = data.is_read == 1 ? .white : UIColor.init(rgb: 0xEEF6FF)
        self.notificationDotImageView.isHidden = data.is_read == 1 ? true : false
        self.viewQuoteButton.setImage(response.contains(data.id ?? 0) ? UIImage(named: Config.Images.eyeIcon) : UIImage(named: Config.Images.quotationIcon), for: .normal)
        isPending = response.contains(data.id ?? 0) ? false : true
        self.viewQuoteButton.addTarget(target, action: #selector(target?.viewQuoteButtonTapped(_:)), for: .touchUpInside)
    }

    func changeColor(color: UIColor = .primaryColor()){
        self.inquiryStatusLabel.textColor = color
        self.viewQuoteButton.tintColor = color
        self.statusImageView.tintColor = color
        
        self.bottomView.backgroundColor = color.withAlphaComponent(0.2)
        self.centerArrowImageView.tintColor = color.withAlphaComponent(0.2)
    }
}
