//
//  OrderListTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 13/02/21.
//

import UIKit

class OrderListTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var headerView1:UIView!
    @IBOutlet var headerView2:UIView!
    @IBOutlet var titleView:UIView!
    @IBOutlet var firstTitleLabel:UILabel!
    @IBOutlet var secondTitleLabel:UILabel!
    @IBOutlet var firstTitleImageView:UIImageView!
    @IBOutlet var secondTitleImageView:UIImageView!
    @IBOutlet var orderNoLabel:UILabel!
    @IBOutlet var styleNoLabel:UILabel!
    @IBOutlet var tableView:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.mainView.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        self.mainView.roundCorners(corners: .allCorners, radius: 10.0)
        self.tableView.roundCorners(corners: .allCorners, radius: 10.0)
        self.mainView.layer.borderWidth = 1.0
        self.mainView.layer.borderColor = UIColor.init(rgb: 0x707070, alpha: 0.2).cgColor
        
        self.tableView.isScrollEnabled = false
        
        self.headerView1.roundCorners(corners: [.topLeft], radius: 10.0)
        self.headerView2.roundCorners(corners: [.topRight], radius: 10.0)
        headerView1.backgroundColor = .primaryColor()
        headerView2.backgroundColor = .primaryColor()
        self.titleView.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
        
        [firstTitleLabel,secondTitleLabel].forEach { (label) in
            label?.font = .appFont(ofSize: 14.0, weight: .medium)
            label?.textColor = .white
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
        }
        
        orderNoLabel.text = "Order No"
        styleNoLabel.text = "Style No"
        [orderNoLabel,styleNoLabel].forEach { (label) in
            label?.font = .appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
        }
        
        [firstTitleImageView,secondTitleImageView].forEach { (imageView) in
            imageView?.tintColor = .white
            imageView?.contentMode = .scaleAspectFit
        }
        
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstTitleLabel.text = ""
        secondTitleLabel.text = ""
        firstTitleImageView.image = nil
        secondTitleImageView.image = nil
        tableView.dataSource = nil
        tableView.reloadData()
    }
    
    func setContent(data:DMSGetOrderListResponseDatum, indexSection:Int, target:OrderListVC?){
        if target?.appDelegate().userDetails.userType == .buyer{
            firstTitleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
            secondTitleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
            firstTitleLabel.text = data.factoryName
            secondTitleLabel.text = data.pcuName
        }else if target?.appDelegate().userDetails.userType == .factory{
            firstTitleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.buyerIcon)
            secondTitleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.pcuIcon)
            firstTitleLabel.text = data.buyerName
            secondTitleLabel.text = data.pcuName
        }else if target?.appDelegate().userDetails.userType == .pcu{
            firstTitleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.buyerIcon)
            secondTitleImageView.image = Config.Images.shared.getImage(imageName: Config.Images.factoryIcon)
            firstTitleLabel.text = data.buyerName
            secondTitleLabel.text = data.factoryName
        }
        
        self.tableView.tag = indexSection
        self.tableView.dataSource = target
        self.tableView.delegate = target
    }
}
