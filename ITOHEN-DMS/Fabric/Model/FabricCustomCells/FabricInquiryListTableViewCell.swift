//
//  FabricInquiryListTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 15/03/23.
//

import UIKit

class FabricInquiryListTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var inquiryNoTitleLabel: UILabel!
    @IBOutlet var inquiryNoLabel: UILabel!
    @IBOutlet var deliveryDateTitleLabel: UILabel!
    @IBOutlet var deliveryDateLabel: UILabel!
    
    @IBOutlet var yarnCountTitleLabel: UILabel!
    @IBOutlet var yarnCountLabel: UILabel!
    @IBOutlet var yarnQtyTitleLabel: UILabel!
    @IBOutlet var yarnQtyLabel: UILabel!
    @IBOutlet var materialTitleLabel: UILabel!
    @IBOutlet var materialLabel: UILabel!
    @IBOutlet var compositionTitleLabel: UILabel!
    @IBOutlet var compositionLabel: UILabel!

    @IBOutlet var inquiryViewButton: UIButton!
    @IBOutlet var inquiryEditButton: UIButton!
    @IBOutlet var inquiryAddButton: UIButton!
    @IBOutlet var inquiryDeleteButton: UIButton!
    @IBOutlet var inquirySendToButton: UIButton!
    @IBOutlet var inquiryResponseButton: UIButton!
    
    var inquiryId: String?
    var data: FabricInquiryListData?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    
        self.mainView.backgroundColor = UIColor(rgb: 0xE7EAEA)
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        self.mainView.layer.borderWidth = 0.2
        self.mainView.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        
        self.bottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius:10)
        
        self.inquiryNoTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "inquiryNoText")): "
        self.deliveryDateTitleLabel.text = "\(LocalizationManager.shared.localizedString(key: "deliveryDateText")): "
        self.yarnCountTitleLabel.text = LocalizationManager.shared.localizedString(key: "yarnCountText")
        self.yarnQtyTitleLabel.text = LocalizationManager.shared.localizedString(key: "yarnQuantityText")
        self.materialTitleLabel.text = LocalizationManager.shared.localizedString(key: "materialText")
        self.compositionTitleLabel.text = LocalizationManager.shared.localizedString(key: "compositionText")
        
        [inquiryNoTitleLabel, deliveryDateTitleLabel, yarnCountTitleLabel, yarnQtyTitleLabel, materialTitleLabel, compositionTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            theLabel?.textColor = UIColor(rgb: 0x838B8B)
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [inquiryNoLabel, deliveryDateLabel, yarnCountLabel, yarnQtyLabel, materialLabel, compositionLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
            theLabel?.textColor = UIColor(rgb: 0x31444A)
           // theLabel?.numberOfLines = 2
           // theLabel?.sizeToFit()
        }
        
        [inquiryViewButton, inquiryResponseButton, inquiryEditButton, inquiryAddButton, inquiryDeleteButton, inquirySendToButton].forEach { (theButton) in
            theButton?.setTitle("", for: .normal)
        }
   
    }

    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.inquiryNoLabel.text = ""
        self.deliveryDateLabel.text = ""
        self.yarnCountLabel.text = ""
        self.yarnQtyLabel.text = ""
        self.materialLabel.text = ""
        self.compositionLabel.text = ""
    }
    
    func setContent(index: Int, data: FabricInquiryListData, target: FabricInquiryListVC?){
        self.data = data
        self.index = index
        self.inquiryId = "\(data.id ?? 0)"

        inquiryNoLabel.text = "IN-\(data.id ?? 0)"
        deliveryDateLabel.text = data.delivery_date?.count == 0 ? "-" :  DateTime.convertDateFormater("\(data.delivery_date ?? "")",
                                                              currentFormat: Date.simpleDateFormat,
                                                              newFormat: RMConfiguration.shared.dateFormat)
        yarnCountLabel.text = data.yarn_count
        yarnQtyLabel.text = data.yarn_quantity
        materialLabel.text = data.meterial
        compositionLabel.text = data.composition
        
        self.inquiryViewButton.addTarget(target, action: #selector(target?.inquiryViewButtonTapped(_:)), for: .touchUpInside)
        self.inquiryEditButton.addTarget(target, action: #selector(target?.inquiryEditButtonTapped(_:)), for: .touchUpInside)
        self.inquiryAddButton.addTarget(target, action: #selector(target?.inquiryAddButtonTapped(_:)), for: .touchUpInside)
        self.inquiryDeleteButton.addTarget(target, action: #selector(target?.inquiryDeleteButtonTapped(_:)), for: .touchUpInside)
        self.inquirySendToButton.addTarget(target, action: #selector(target?.inquirySendToButtonTapped(_:)), for: .touchUpInside)
        self.inquiryResponseButton.addTarget(target, action: #selector(target?.inquiryResponseButtonTapped(_:)), for: .touchUpInside)
        
        self.inquiryEditButton.isUserInteractionEnabled = data.supplier_ids?.count ?? 0 > 0 ? false : true
        self.inquiryEditButton.isEnabled = data.supplier_ids?.count ?? 0 > 0 ? false : true
        
        // For Edit Fabric Inquiry Permission
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editFabricInquiry.rawValue) == false {
            self.inquiryEditButton.isHidden = true
        }
     
        // For view supplier response Permission
       if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewSupplierResponse.rawValue) == false {
           self.inquiryResponseButton.isHidden = true
       }
       
        // For inquiry SendTo Permission
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.sentToSupplier.rawValue) == false {
            self.inquirySendToButton.isHidden = true
            self.inquiryAddButton.isHidden = true
        }else{
            self.inquirySendToButton.isHidden = false
            self.inquiryAddButton.isHidden = false
        }
        
        // For delete Fabric Inquiry Permission
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.deleteFabricInquiry.rawValue) == false {
            self.inquiryDeleteButton.isHidden = true
        }
    }
}


