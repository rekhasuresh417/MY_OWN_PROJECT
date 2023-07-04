//
//  ProductionContentViewTVCell.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 03/02/21.
//

import UIKit

class ProductionContentViewTVCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var editButton:UIButton!
    @IBOutlet var cutBarLabel:UILabel!
    @IBOutlet var sewBarLabel:UILabel!
    @IBOutlet var packBarLabel:UILabel!
    @IBOutlet var cutBarView:MBCircularProgressBarView!
    @IBOutlet var sewBarView:MBCircularProgressBarView!
    @IBOutlet var packBarView:MBCircularProgressBarView!
    
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
        
        titleLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "productionProgressText")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        [cutBarLabel,sewBarLabel,packBarLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .center
            label?.numberOfLines = 1
            if label == cutBarLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "cuttingText")
            }else if label == sewBarLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "sewingText")
            }else if label == packBarLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "packingText")
            }
        }
        
        self.editButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.editInfoIcon), for: .normal)
        self.editButton.backgroundColor = .clear
        self.editButton.tintColor = .primaryColor()
        
        self.cutBarView.maxValue = 100.0
        self.cutBarView.progressColor = .primaryColor()
        self.cutBarView.emptyLineColor = .primaryColor(withAlpha: 0.4)
        self.cutBarView.decimalPlaces = 2
        self.cutBarView.valueFontSize = 14.0
        self.cutBarView.valueFontSize = 14.0
        
        self.sewBarView.maxValue = 100.0
        self.sewBarView.progressColor = UIColor.init(rgb: 0xFF9957)
        self.sewBarView.emptyLineColor = UIColor.init(rgb: 0xFF9957, alpha: 0.4)
        self.sewBarView.decimalPlaces = 2
        self.sewBarView.valueFontSize = 14.0
        self.sewBarView.valueFontSize = 14.0
        
        self.packBarView.maxValue = 100.0
        self.packBarView.progressColor = UIColor.init(rgb: 0xC92121)
        self.packBarView.emptyLineColor = UIColor.init(rgb: 0xC92121, alpha: 0.4)
        self.packBarView.decimalPlaces = 2
        self.packBarView.valueFontSize = 14.0
        self.packBarView.valueFontSize = 14.0
    }
    
    func setContet(model:ProductionData?, target:OrderInfoVC?){
        
        if let data = model{
            if data.cuttingDataFeed{
                self.enableProgressBarView(view: cutBarView, label: cutBarLabel)
                self.cutBarView.value = data.cutPerc ?? 0.0
            }else{
                self.disableProgressBarView(view: cutBarView, label: cutBarLabel)
            }
            if data.sewingDataFeed{
                self.enableProgressBarView(view: sewBarView, label: sewBarLabel)
                self.sewBarView.value = data.sewPerc ?? 0.0
            }else{
                self.disableProgressBarView(view: sewBarView, label: sewBarLabel)
            }
            if data.packingDataFeed{
                self.enableProgressBarView(view: packBarView, label: packBarLabel)
                self.packBarView.value = data.packPerc ?? 0.0
            }else{
                self.disableProgressBarView(view: packBarView, label: packBarLabel)
            }
        }
        
        self.editButton.addTarget(target, action: #selector(target?.addProductionButtonTapped(_:)), for: .touchUpInside)
    }
    
    func enableProgressBarView(view:MBCircularProgressBarView, label:UILabel){
        view.layer.opacity = 1.0
        label.layer.opacity = 1.0
    }
    
    func disableProgressBarView(view:MBCircularProgressBarView, label:UILabel){
        view.layer.opacity = 0.3
        label.layer.opacity = 0.3
        view.value = 0.0
    }
}
