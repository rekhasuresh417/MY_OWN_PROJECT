//
//  SupplierResponseTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 29/03/23.
//

import UIKit

class SupplierResponseTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var supplierNameTitleLabel: UILabel!
    @IBOutlet var supplierNameLabel: UILabel!
    @IBOutlet var contactNameTitleLabel: UILabel!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var phoneNumberTitleLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var priceTitleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
      
    }

    override func prepareForReuse() {
        super.prepareForReuse()
     
        self.supplierNameLabel.text = ""
        self.contactNameLabel.text = ""
        self.phoneNumberLabel.text = ""
    }
    
    func setContent(index: Int, data: FabricSupplierData, target: UIViewController?){
        
        self.index = index
        self.supplierNameLabel.text = data.supplier
        self.contactNameLabel.text = data.contact_person
        self.phoneNumberLabel.text = data.contact_number
     
        let attText: NSMutableAttributedString = target!.getAttributedText(firstString: "\(LocalizationManager.shared.localizedString(key: "priceText")): ",
                                                                          firstFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                          firstColor: .lightGray,
                                                                          secondString: "\(data.price ?? 0)",
                                                                          secondFont: UIFont.appFont(ofSize: 13.0, weight: .medium),
                                                                          secondColor: .delayedColor())
        
        self.priceTitleLabel.attributedText = attText
  
    }
}
