//
//  FactoryResponseTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 24/01/23.
//

import UIKit

class FactoryResponseTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var factoryTitleLabel: UILabel!
    @IBOutlet var contactNameTitleLabel: UILabel!
    @IBOutlet var factoryLabel: UILabel!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var phoneNumberTitleLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var priceTitleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var generatePOView: UIView!
    @IBOutlet var generatePOViewHConstraint: NSLayoutConstraint!
    @IBOutlet var generatePoLabel: UILabel!
    @IBOutlet var generatePOButton: UIButton!
    
    var data: FactoryResponseData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    
        self.factoryTitleLabel.text = LocalizationManager.shared.localizedString(key: "factoryText")
        self.contactNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "contactName_text")
        self.phoneNumberTitleLabel.text = LocalizationManager.shared.localizedString(key: "phoneNumberText")
        self.priceTitleLabel.text = LocalizationManager.shared.localizedString(key: "priceText")
        
        self.generatePoLabel.text = LocalizationManager.shared.localizedString(key: "generatePOText")
        
        [factoryTitleLabel, contactNameTitleLabel, phoneNumberTitleLabel, priceTitleLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            theLabel?.textColor = .gray
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        [factoryLabel, contactNameLabel, phoneNumberLabel, priceLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .medium)
            theLabel?.textColor = theLabel == priceLabel ? .delayedColor() : .customBlackColor()
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
        self.generatePOButton.setTitle("", for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.factoryLabel.text = ""
        self.contactNameLabel.text = ""
        self.phoneNumberLabel.text = ""
        self.priceLabel.text = ""
    }
    
    func setContent(data: FactoryResponseData, isFrom: Bool, target:FactoryResponseVC?){
        self.data = data
        
        self.factoryLabel.text = data.factory
        self.contactNameLabel.text = data.contact_person
        self.phoneNumberLabel.text = data.contact_number
        self.priceLabel.text = "\(data.price ?? 0)"
    
        self.generatePOButton.addTarget(target, action: #selector(target?.generatePOButtonTapped(_:)), for: .touchUpInside)
     
        // For generate PO Permission
        if (RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.generatePO.rawValue) == false) || isFrom == true{
            self.generatePOView.isHidden = true
            self.generatePOViewHConstraint.constant = 0
        }
        
    }

}
