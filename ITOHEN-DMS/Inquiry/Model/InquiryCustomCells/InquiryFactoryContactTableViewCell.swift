//
//  InquiryFactoryContactTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 12/04/23.
//

import UIKit

class InquiryFactoryContactTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var supplierNameTitleLabel: UILabel!
    @IBOutlet var supplierNameLabel: UILabel!
    @IBOutlet var contactNameTitleLabel: UILabel!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var phoneNumberTitleLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailTitleLabel: UILabel!
    @IBOutlet var selectSuppliersButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var checkBoxButtonWConstraint: NSLayoutConstraint!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.mainView.backgroundColor = .white
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.borderWidth = 0.1
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.stackView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        self.view1.roundCorners(corners: [.topLeft], radius: 8)
        self.view3.roundCorners(corners: [.topRight], radius: 8)
        
        self.bottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        
        self.mainView.applyLightShadow()
        
        self.supplierNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "supplierText")
        self.contactNameTitleLabel.text = LocalizationManager.shared.localizedString(key: "contactPersonText")
        self.phoneNumberTitleLabel.text = LocalizationManager.shared.localizedString(key: "contactNumberText")
        self.emailTitleLabel.text = LocalizationManager.shared.localizedString(key: "emailText")
        self.selectSuppliersButton.setTitle("", for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.supplierNameLabel.text = ""
        self.contactNameLabel.text = ""
        self.phoneNumberLabel.text = ""
    }
    
    func setContent(index: Int, data: InquiryFactoryListData, selectedData: [InquiryFactoryListData], tempSelectedData: [InquiryFactoryListData],  isSent: Bool = false, target: InquiryFactoryContactVC?){
        
        self.index = index
        self.supplierNameLabel.text = data.factory
        self.contactNameLabel.text = data.contact_person
        self.phoneNumberLabel.text = data.contact_number
     
        let attText: NSMutableAttributedString = target!.getAttributedText(firstString: "\(LocalizationManager.shared.localizedString(key: "emailText")): ",
                                                                          firstFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                          firstColor: .lightGray,
                                                                          secondString: data.contact_email ?? "",
                                                                          secondFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                          secondColor: .customBlackColor())
        
        self.emailTitleLabel.attributedText = attText
  
        let containData = selectedData.filter({$0.id == data.id})
        self.selectSuppliersButton.setImage(containData.count > 0 ? UIImage.init(named: "ic_inquiry_checkbox_tick") : UIImage.init(named: "checkbox"), for: .normal)
        self.selectSuppliersButton.addTarget(target, action: #selector(target?.checkBoxSelection(_:)), for: .touchUpInside)
        
        let tempData = tempSelectedData.filter({$0.id == data.id})
        self.selectSuppliersButton.isEnabled = tempData.count > 0 ? false : true
        self.selectSuppliersButton.isUserInteractionEnabled = tempData.count > 0 ? false : true
        
        self.selectSuppliersButton.isHidden = isSent == true ? true : false
        self.checkBoxButtonWConstraint.constant = isSent == true ? 0.0 : 30.0
        self.emailTitleLabel.textAlignment = isSent == true ? .center : .left
        
    }
}
