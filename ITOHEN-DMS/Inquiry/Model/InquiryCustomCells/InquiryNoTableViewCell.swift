//
//  InquiryNoTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 24/01/23.
//

import UIKit

class InquiryNoTableViewCell: UITableViewCell {
    
    @IBOutlet var inquiryNoLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    
        [inquiryNoLabel].forEach{ (theLabel) in
            theLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
            theLabel?.textColor = .customBlackColor()
            theLabel?.textAlignment = .left
            theLabel?.numberOfLines = 1
            theLabel?.sizeToFit()
        }
   
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.inquiryNoLabel.text = "-"
    }
    
    func setContent(data: InquiryListData, target:UIViewController?){
        self.inquiryNoLabel.text = "IN-\(data.id ?? 0)"
    }

    func setFactoryContent(data: FactoryInquiryResponseData, target:UIViewController?){
        self.inquiryNoLabel.text = "IN-\(data.id ?? 0)"
    }
}
