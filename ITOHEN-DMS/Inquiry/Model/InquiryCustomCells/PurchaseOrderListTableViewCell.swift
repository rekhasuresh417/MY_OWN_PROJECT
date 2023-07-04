//
//  PurchaseOrderListTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 17/04/23.
//

import UIKit

class PurchaseOrderListTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var poIdTitleLabel: UILabel!
    @IBOutlet var InquiryIdTitleLabel: UILabel!
    @IBOutlet var factoryTitleLabel: UILabel!
    @IBOutlet var poIdLabel: UILabel!
    @IBOutlet var InquiryIdLabel: UILabel!
    @IBOutlet var factoryLabel: UILabel!
    @IBOutlet var viewPOButton: UIButton!
    @IBOutlet var cancelPOButton: UIButton!
    @IBOutlet var bottomStackView: UIStackView!
    
    var data: PurchaseOrderListData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.roundCorners(corners: .allCorners, radius: 8)
        self.mainView.applyLightShadow()
        self.mainView.layer.borderWidth = 0.2
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.bottomStackView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        self.cancelPOButton.roundCorners(corners: [.bottomRight], radius: 8)
        self.viewPOButton.roundCorners(corners: [.bottomLeft], radius: 8)
      
        self.selectionStyle = .none
    
        self.factoryTitleLabel.text = LocalizationManager.shared.localizedString(key: "factoryText")
        self.poIdTitleLabel.text = LocalizationManager.shared.localizedString(key: "poIdText")
        self.InquiryIdTitleLabel.text = LocalizationManager.shared.localizedString(key: "inquiryIdText")
                
        [factoryTitleLabel, poIdTitleLabel, InquiryIdTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            theLabel?.textColor = .gray
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [factoryLabel, poIdLabel, InquiryIdLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .medium)
            theLabel?.textColor = .customBlackColor()
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        self.viewPOButton.setTitle(LocalizationManager.shared.localizedString(key: "viewButtonText"), for: .normal)
        self.cancelPOButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.factoryLabel.text = ""
        self.poIdLabel.text = ""
        self.InquiryIdLabel.text = ""
    }
    
    func setContent(data: PurchaseOrderListData, target:PurchaseOrderListVC?){
        self.data = data
        
        self.factoryLabel.text = data.factory
        self.poIdLabel.text = "PO-\(data.po_id ?? 0)"
        self.InquiryIdLabel.text = "IN-\(data.inquiry_id ?? 0)"
        
        if data.po_status == 1{
            self.viewPOButton.isHidden = false
            self.cancelPOButton.isHidden = false
            self.viewPOButton.isUserInteractionEnabled = true
            self.cancelPOButton.isUserInteractionEnabled = true
            self.cancelPOButton.setTitleColor(.black, for: .normal)
            self.viewPOButton.setTitle(LocalizationManager.shared.localizedString(key: "viewButtonText"), for: .normal)
            self.cancelPOButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        }else if data.po_status == 2{
            self.viewPOButton.isHidden = true
            self.cancelPOButton.isHidden = false
            self.cancelPOButton.setTitleColor(.inquiryPrimaryColor(), for: .normal)
            self.cancelPOButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelledButtonText"),
                                         for: .normal)
            self.viewPOButton.isUserInteractionEnabled = false
            self.cancelPOButton.isUserInteractionEnabled = false
        }else{ // po_status == 0
            self.viewPOButton.isHidden = true
            self.cancelPOButton.isHidden = false
            self.cancelPOButton.setTitleColor(.black, for: .normal)
            self.cancelPOButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
            self.viewPOButton.isUserInteractionEnabled = true
            self.cancelPOButton.isUserInteractionEnabled = true
        }
       
        
        self.viewPOButton.addTarget(target, action: #selector(target?.viewPOButtonTapped(_:)), for: .touchUpInside)
        self.cancelPOButton.addTarget(target, action: #selector(target?.cancelPOButtonTapped(_:)), for: .touchUpInside)
        
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.cancelPO.rawValue) == false {
            self.cancelPOButton.isHidden = data.po_status == 2 ? false : true
        }
    }

}
