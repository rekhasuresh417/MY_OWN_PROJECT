//
//  OrderStatusContentTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 15/02/21.
//

import UIKit

class OrderStatusContentTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var styleValueLabel:UILabel!
    @IBOutlet var delayedTaskValueLabel:UILabel!
    @IBOutlet var previewButton:UIButton!
    @IBOutlet var cuttingImageView:UIImageView!
    @IBOutlet var sewingImageView:UIImageView!
    @IBOutlet var packingImageView:UIImageView!
    @IBOutlet var cuttingPercLabel:UILabel!
    @IBOutlet var sewingPercLabel:UILabel!
    @IBOutlet var packingPercLabel:UILabel!
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var seperatorLine: UILabel!
    
    var orderId:String = "0"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        self.mainView.backgroundColor = .white
        firstView.roundCorners(corners: [.bottomLeft], radius: 10.0)
        thirdView.roundCorners(corners: [ .bottomRight], radius: 10.0)
        
        [styleValueLabel, delayedTaskValueLabel].forEach { (label) in
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            label?.font = .appFont(ofSize: 14.0, weight: .medium)
            
            if label == self.delayedTaskValueLabel{
                label?.textColor = UIColor.init(rgb: 0xD4313C, alpha: 0.7)
            }
        }
        
        self.previewButton.tintColor = .darkGray
        self.previewButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.previewIcon), for: .normal)
        
        [cuttingImageView, sewingImageView, packingImageView].forEach { (imageView) in
            imageView?.tintColor = .primaryColor()
            imageView?.contentMode = .scaleAspectFit
            if imageView == self.cuttingImageView{
                imageView?.image = Config.Images.shared.getImage(imageName: Config.Images.cuttingIcon)
            }else if imageView == self.sewingImageView{
                imageView?.image = Config.Images.shared.getImage(imageName: Config.Images.sewingIcon)
            }else if imageView == self.packingImageView{
                imageView?.image = Config.Images.shared.getImage(imageName: Config.Images.packingIcon)
            }
            imageView?.alpha = 0.7
        }
        
        [cuttingPercLabel, sewingPercLabel, packingPercLabel].forEach { (label) in
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
            label?.adjustsFontSizeToFitWidth = true
            label?.font = .appFont(ofSize: 13.0, weight: .regular)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.styleValueLabel.text = ""
        self.delayedTaskValueLabel.text = ""
        self.previewButton.tintColor = .darkGray
    }
    
    func setContent(data:OrderStatusData, target:OrderStatusVC?){
        self.orderId = data.orderID
        
        self.styleValueLabel.text = data.styleNo
        self.delayedTaskValueLabel.text = data.pendingTasks
        self.cuttingPercLabel.text = data.cuttingCompletion + "%"
        self.sewingPercLabel.text = data.sewingCompletion + "%"
        self.packingPercLabel.text = data.packingCompletion + "%"
        
        if let taskCount = Int(data.pendingTasks), taskCount > 0{
            self.previewButton.tintColor = UIColor.init(rgb: 0xD4313C)
        }else{
            self.previewButton.tintColor = .darkGray
        }
        self.previewButton.tag = Int(data.orderID) ?? 0
        self.previewButton.addTarget(target, action: #selector(target?.previewButtonTapped(_:)), for: .touchUpInside)
        self.previewButton.alpha = 0.7

    }
}
