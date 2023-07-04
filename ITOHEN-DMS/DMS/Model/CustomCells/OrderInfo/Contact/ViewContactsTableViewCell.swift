//
//  ViewContactsTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class ViewContactsTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var editButton:UIButton!
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var viewContactButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        
        self.mainView.backgroundColor = .white
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.mainView.layer.shadowRadius = 3.0
        self.mainView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.mainView.layer.masksToBounds = false
        self.mainView.roundCorners(corners: .allCorners, radius: 8.0)
        
        titleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "contactTitleText")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        
        self.editButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.editInfoIcon), for: .normal)
        self.editButton.backgroundColor = .clear
        self.editButton.tintColor = .primaryColor()
        
        self.viewContactButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "viewContactText"), for: .normal)
        self.viewContactButton.backgroundColor = .clear
        self.viewContactButton.setTitleColor(.primaryColor(), for: .normal)
        self.viewContactButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 10.0
            layout.minimumInteritemSpacing = 10.0
            layout.scrollDirection = .horizontal
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.reloadInputViews()
        self.collectionView.reloadData()
    }
    
    func setContent(target:OrderInfoVC?){
        self.collectionView.tag = 101
        self.collectionView.dataSource = target
        self.collectionView.delegate = target
        self.viewContactButton.tag = target!.viewTag // view contacts
        self.viewContactButton.addTarget(target, action: #selector(target?.addOrViewContactButtonTapped(_:)), for: .touchUpInside)
        self.editButton.tag = target!.editTag // edit/add contacts
        self.editButton.addTarget(target, action: #selector(target?.addOrViewContactButtonTapped(_:)), for: .touchUpInside)
    }
}
