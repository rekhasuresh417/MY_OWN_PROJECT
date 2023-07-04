//
//  MulitiImagesCollectionViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 02/05/23.
//

import UIKit
import SDWebImage

class MultiImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    
    var data: InquiryUploadedFiles?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deleteButton.setTitle("", for: .normal)
        self.imageLabel.text = ""
        self.imageView.layer.borderWidth = 0.5
        self.imageView.layer.borderColor = UIColor.lightGray.cgColor
        self.imageView.roundCorners(corners: .allCorners, radius: 8)
        self.deleteButton.roundCorners(corners: .allCorners, radius: 8)
    }
    
    func setContent(data: InquiryUploadedFiles?, serverURL: String, target: InquiryChatContentVC?){
        self.data = data
        imageView.sd_setImage(with: URL(string: "\(serverURL)\(data?.content ?? "")"), placeholderImage: nil)
        self.deleteButton.addTarget(target, action: #selector(target?.deleteButtonTapped(_:)), for: .touchUpInside)
    }
}
