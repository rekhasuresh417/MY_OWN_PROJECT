//
//  MaterialsAndLabelListTableViewCell.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 24/04/23.
//

import UIKit
import SDWebImage

class MaterialsAndLabelListTableViewCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var headerTitleLabel: UILabel!
    @IBOutlet var topImageStackView: UIStackView!
    @IBOutlet var bottomImageStackView: UIStackView!
    @IBOutlet var descriptionsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image4BackgroundView: UIView!
    @IBOutlet var imagesBackgroundView: UIView!
    @IBOutlet var plusImagesLabel: UILabel!
    
    @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    @IBOutlet var bottomImageStackViewHConstraint: NSLayoutConstraint!
    @IBOutlet var statusViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet var statusView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var addButtonWConstraint: NSLayoutConstraint!
    @IBOutlet var edityButtonWConstraint: NSLayoutConstraint!
    
    var data: InquiryPOModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = UIColor.lightGray.cgColor
        
        descriptionsLabel.font = UIFont.appFont(ofSize: 11.0, weight: .regular)
       // dateLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        dateLabel.textAlignment = .left
        
        plusImagesLabel.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
        plusImagesLabel.layer.cornerRadius = self.plusImagesLabel.frame.height/2
        plusImagesLabel.clipsToBounds = true
        
        plusImagesLabel.isHidden = true
        addButton.setTitle("", for: .normal)
        editButton.setTitle("", for: .normal)
        
        /*[image1, image2, image3, image4].forEach{(theImage) in
            theImage?.layer.borderWidth = 0.2
            theImage?.layer.borderColor = UIColor.lightGray.cgColor
            theImage?.roundCorners(corners: .allCorners, radius: 8)
        }*/
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.descriptionsLabel.text = ""
        self.dateLabel.text = ""
        [image1, image2, image3, image4].forEach{(theImage) in
            theImage?.image = nil
        }
    }

    func setContent(index: Int, rowCount: Int, data: InquiryPOModel, target: MaterialsAndLabelsListVC?) {
        
        self.data = data
        
        self.statusView.isHidden = rowCount-1 == index ? false : true
        self.addButton.isHidden = data.status == 0 ? true : false
        self.addButtonWConstraint.constant = data.status == 0 ? 0 : 30
        self.editButton.isHidden = data.status == 1 ? true : false
        //self.editButton.isHidden = data.text?.debugDescription.removingWhitespaces().count ?? 0>0 ? false : true
        
        self.descriptionsLabel.attributedText = (data.text?.joined(separator: ""))?.htmlToAttributedString
        self.headerTitleLabel.text = data.type
        
        self.dateLabel.text = "\(data.printUser ?? "") \(data.printDate ?? "")"
        if data.image?.count == 1{
            image1.sd_setImage(with: URL(string: data.image?[0] ?? ""), placeholderImage: nil)
        }else if data.image?.count == 2{
            image1.sd_setImage(with: URL(string: data.image?[0] ?? ""), placeholderImage: nil)
            image2.sd_setImage(with: URL(string: data.image?[1] ?? ""), placeholderImage: nil)
        }else if data.image?.count == 3{
            image1.sd_setImage(with: URL(string: data.image?[0] ?? ""), placeholderImage: nil)
            image2.sd_setImage(with: URL(string: data.image?[1] ?? ""), placeholderImage: nil)
            image3.sd_setImage(with: URL(string: data.image?[2] ?? ""), placeholderImage: nil)
        }else if data.image?.count ?? 0 >= 4{
            image1.sd_setImage(with: URL(string: data.image?[0] ?? ""), placeholderImage: nil)
            image2.sd_setImage(with: URL(string: data.image?[1] ?? ""), placeholderImage: nil)
            image3.sd_setImage(with: URL(string: data.image?[2] ?? ""), placeholderImage: nil)
            image4.sd_setImage(with: URL(string: data.image?[3] ?? ""), placeholderImage: nil)
       }
        
        if data.image?.count ?? 0 > 4 { // count > 4
            self.plusImagesLabel.text = " + \((data.image?.count ?? 0) - 4) "
        }
        
        let tapGesture = UITapGestureRecognizer(target: target, action: #selector(target?.multiImageViewTapped(sender:)))
        imagesBackgroundView.addGestureRecognizer(tapGesture)
  
        
        self.addButton.addTarget(target, action: #selector(target?.addButtonTapped(_:)), for: .touchUpInside)
        self.editButton.addTarget(target, action: #selector(target?.editButtonTapped(_:)), for: .touchUpInside)
        
        plusImagesLabel.isHidden = data.image?.count ?? 0 > 4 ? false : true
        self.topViewHConstraint.constant = index == 0 ? 30 : 0
        
        if RMConfiguration.shared.loginType == Config.Text.staff && target?.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addAndEditMaterialsAndLabels.rawValue) == false {
            self.addButton.isHidden = true
            self.editButton.isHidden = true
        }
        
    /*    if data.image?.count == 0{
           // self.bottomImageStackViewHConstraint.constant = 0
            self.bottomImageStackView.isHidden = true
            self.image2.isHidden = true
        }else if data.image?.count == 1{
           // self.bottomImageStackViewHConstraint.constant = 0
            self.bottomImageStackView.isHidden = true
            self.image2.isHidden = true
        }else if data.image?.count == 2{
           // self.bottomImageStackViewHConstraint.constant = 0
            self.bottomImageStackView.isHidden = true
            self.image2.isHidden = false
        }else if data.image?.count == 3{
           // self.bottomImageStackViewHConstraint.constant = 0
            self.bottomImageStackView.isHidden = false
            self.image2.isHidden = false
            self.image3.isHidden = false
        }else{
            self.bottomImageStackView.isHidden = false
            self.image2.isHidden = false
        }
      */
    }
    
}
