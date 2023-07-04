//
//  InquiryPOMultiImageTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 27/04/23.
//

import UIKit

class InquiryPOMultiImageTableViewCell: UITableViewCell {
    
    @IBOutlet var multiImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    func setContent(data: String, target: InquiryPOMultiImageVC?){
        self.multiImageView.sd_setImage(with: URL(string: data), placeholderImage: UIImage(named: "ic_placeholder_new"))
    }
 
}
