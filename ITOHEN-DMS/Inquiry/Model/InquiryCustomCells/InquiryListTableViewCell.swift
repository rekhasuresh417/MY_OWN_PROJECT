//
//  InquiryListTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 23/01/23.
//

import UIKit

class InquiryListTableViewCell: UITableViewCell {

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
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    
    @IBOutlet var notificationDotImageView: UIImageView!
    @IBOutlet var addFactoryContactButton: UIButton!
    @IBOutlet var addSentToInquiryButton: UIButton!
    @IBOutlet var inquiryViewButton: UIButton!
    @IBOutlet var inquiryFactoryResponseButton: UIButton!
    @IBOutlet var inquiryDeleteButton: UIButton!
    
    var inquiryId: String?
    var data: InquiryListData?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        self.mainView.layer.borderWidth = 0.2
        self.mainView.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        
        self.bottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius:10)
        self.view1.roundCorners(corners: [.topLeft, .topRight], radius:10)
        self.view4.roundCorners(corners: [.bottomLeft, .bottomRight], radius:10)
        
        self.inquiryNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryNoText")
        self.inquiryDateTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryDateText")
        self.styleNoTitleLabel.text = LocalizationManager.shared.localizedString(key: "styleNoText")
        self.itemNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "itemNameText")
        
        [inquiryNoTitleLabel, inquiryDateTitleLabel, styleNoTitleLabel, itemNameTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [inquiryNoLabel, inquiryDateLabel, styleNoLabel, itemNameLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            theLabel?.textColor = .gray
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
        
        [addFactoryContactButton, addSentToInquiryButton, inquiryViewButton, inquiryFactoryResponseButton, inquiryDeleteButton].forEach{ (theButton) in
            theButton?.setTitle("", for: .normal)
            theButton?.tintColor = .gray
        }
 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.inquiryNoLabel.text = ""
        self.inquiryDateLabel.text = ""
        self.styleNoLabel.text = ""
        self.itemNameLabel.text = ""
    }
    
    func setContent(index: Int, data: InquiryListData, target: InquiryListVC?){
        self.data = data
        self.index = index
        self.inquiryId = "\(data.id ?? 0)"
     
        self.inquiryNoLabel.text = "IN-\(data.id ?? 0)"
        self.inquiryDateLabel.text = DateTime.convertDateFormater("\(data.created_date ?? "")",
                                                                  currentFormat: Date.simpleDateFormat,
                                                                  newFormat: RMConfiguration.shared.dateFormat)
        self.styleNoLabel.text = data.style_no
        self.itemNameLabel.text = data.name
     
        self.inquiryViewButton.addTarget(target, action: #selector(target?.inquiryDownloadButtonTapped(_:)), for: .touchUpInside)
        self.inquiryFactoryResponseButton.addTarget(target, action: #selector(target?.inquiryViewButtonTapped(_:)), for: .touchUpInside)
        self.addFactoryContactButton.addTarget(target, action: #selector(target?.addFactoryContactButtonTapped(_:)), for: .touchUpInside)
        self.addSentToInquiryButton.addTarget(target, action: #selector(target?.addSentToInquiryButtonTapped(_:)), for: .touchUpInside)
        self.inquiryDeleteButton.addTarget(target, action: #selector(target?.inquiryDeleteButtonTapped(_:)), for: .touchUpInside)
        
        self.inquiryDeleteButton.isEnabled = data.is_po_generated == 1 ? false : true
        self.inquiryDeleteButton.tintColor = data.is_po_generated == 1 ? UIColor.lightGray : UIColor.gray
        self.inquiryDeleteButton.isUserInteractionEnabled = data.is_po_generated == 1 ? false : true
        
        // Add factory disable id one contact added
        self.addFactoryContactButton.isEnabled = data.is_po_generated == 1 ? false : true
        self.addFactoryContactButton.tintColor = data.is_po_generated == 1 ? UIColor.lightGray : UIColor.gray
        self.addFactoryContactButton.isUserInteractionEnabled = data.is_po_generated == 1 ? false : true
        
        self.mainView.backgroundColor = data.notification == nil ? .white : UIColor.init(rgb: 0xEEF6FF)
        self.notificationDotImageView.isHidden = data.notification == nil ? true : false
        
        // For Edit Fabric Inquiry Permission
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.buyerViewResponse.rawValue) == false {
            self.inquiryFactoryResponseButton.isHidden = true
        }
     
        // For view supplier response Permission
       if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewFabricInquiry.rawValue) == false {
           self.inquiryViewButton.isHidden = true
       }
       
        // For inquiry SendTo Permission
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.buyerSentToFactory.rawValue) == false {
            self.addSentToInquiryButton.isHidden = true
            self.addFactoryContactButton.isHidden = true
        }else{
            self.addSentToInquiryButton.isHidden = false
            self.addFactoryContactButton.isHidden = false
        }
        
        // For delete Fabric Inquiry Permission
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.buyerDeleteInquiry.rawValue) == false {
            self.inquiryDeleteButton.isHidden = true
        }
    }

}
