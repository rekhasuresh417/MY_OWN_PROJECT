//
//  OrderListContentTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 13/02/21.
//

import UIKit

class OrderListContentTVCell: UITableViewCell {
    @IBOutlet var mainView:UIView!
    @IBOutlet var orderNoLabel:UILabel!
    @IBOutlet var styleLabel:UILabel!
 //   @IBOutlet var statusButton:UIButton!
    @IBOutlet var rightArrowButton:UIButton!
    @IBOutlet var seperatorLine: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var firstLabel:UILabel!
    @IBOutlet var secondLabel:UILabel!
    @IBOutlet var thirdLabel:UILabel!
    @IBOutlet var fourthLabel:UILabel!
    @IBOutlet var firstImageView:UIImageView!
    @IBOutlet var secondImageView:UIImageView!
    @IBOutlet var thirdImageView:UIImageView!
    @IBOutlet var fourthImageView:UIImageView!
    @IBOutlet var firstView: UIView!
    @IBOutlet var fourthView: UIView!
    
    var orderId:String = "0"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.mainView.backgroundColor = .white
        self.mainView.roundCorners(corners: .allCorners, radius: 10.0)
        self.firstView.roundCorners(corners: .bottomLeft, radius: 10.0)
        self.fourthView.roundCorners(corners: .bottomRight, radius: 10.0)
        self.stackView.backgroundColor = .white
        self.stackView.roundCorners(corners: .allCorners, radius: 10.0)
        self.firstView.backgroundColor = .clear
        self.fourthView.backgroundColor = .clear
    
        [orderNoLabel,styleLabel].forEach { (label) in
            label?.font = .appFont(ofSize: 14.0, weight: .medium)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
        }
       
        [firstLabel,secondLabel,thirdLabel,fourthLabel].forEach { (label) in
            label?.font = .appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            if label == firstLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderStatusPopupVC", key2: "skuText")
            }else if label == secondLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderStatusPopupVC", key2: "contactText")
            }else if label == thirdLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderStatusPopupVC", key2: "taskText")
            }else if label == fourthLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderStatusPopupVC", key2: "productionText")
            }
        }
        
        self.rightArrowButton.isUserInteractionEnabled = false

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.orderNoLabel.text = ""
        self.styleLabel.text = ""
    }
    
    func setContent(data:OrderDetailsData, target:OrderListVC?){
        self.orderId = data.orderID
        
        self.orderNoLabel.text = data.orderNo
        self.styleLabel.text = data.styleNo
        self.rightArrowButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.rightArrowIcon), for: .normal)

        firstImageView.image = Config.Images.shared.getImage(imageName: data.skuStatus == "1" ? Config.Images.roundTickIcon : Config.Images.closeIcon)
        secondImageView.image = Config.Images.shared.getImage(imageName: data.contactStatus == "1" ? Config.Images.roundTickIcon : Config.Images.closeIcon)
        thirdImageView.image = Config.Images.shared.getImage(imageName: data.taskStatus == "1" ? Config.Images.roundTickIcon : Config.Images.closeIcon)
        fourthImageView.image = Config.Images.shared.getImage(imageName: data.prodStatus == "1" ? Config.Images.roundTickIcon : Config.Images.closeIcon)
        

    }
}
