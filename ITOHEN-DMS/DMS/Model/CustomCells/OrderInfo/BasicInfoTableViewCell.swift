//
//  BasicInfoTableViewCell.swift
//  Itohen-dms
//
//  Created by Dharma on 12/01/21.
//

import UIKit

class BasicInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView:UIView!
    
    @IBOutlet var buyerLabel:UILabel!
    @IBOutlet var buyerValueLabel:UILabel!
    @IBOutlet var factoryLabel:UILabel!
    @IBOutlet var factoryValueLabel:UILabel!
    @IBOutlet var pcuLabel:UILabel!
    @IBOutlet var pcuValueLabel:UILabel!
    @IBOutlet var orderNoLabel:UILabel!
    @IBOutlet var orderNoValueLabel:UILabel!
    @IBOutlet var styleNoLabel:UILabel!
    @IBOutlet var styleNoValueLabel:UILabel!
    
    @IBOutlet var colorSizeView:UIView!
    @IBOutlet var colorSizeSwitch:UISwitch!
    @IBOutlet var colorSwitchLabel:UILabel!
    @IBOutlet var sizeSwitchLabel:UILabel!
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var cvBackgroundView:UIView!
    
    @IBOutlet var skuButton:UIButton!
    @IBOutlet var editButton:UIButton!
    
    @IBOutlet var colorSizeViewHeightConstraint:NSLayoutConstraint!
    
    var isSkuDataAvailable:Bool = false{
        didSet{
            self.showOrHideColorAndSizeViews()
        }
    }
    
    var skuType:SKUTypes = .size {
        didSet{
            self.updateColorAndSizeLabel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.colorSizeView.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.mainView.backgroundColor = .white
        
        self.mainView.layer.shadowOpacity = 0.5
        self.mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.mainView.layer.shadowRadius = 3.0
        self.mainView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.mainView.layer.masksToBounds = false
        self.mainView.layer.cornerRadius = 8.0
        
        [buyerLabel,factoryLabel,pcuLabel,orderNoLabel,styleNoLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
            label?.textColor = .lightGray
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.sizeToFit()
            
            if label == buyerLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "buyerText")
            }else if label == factoryLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "factoryText")
            }else if label == pcuLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "productionControlText")
            }else if label == orderNoLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "orderNoText")
            }else if label == styleNoLabel{
                label?.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "styleNoText")
            }
        }
        
        [buyerValueLabel,factoryValueLabel,pcuValueLabel,orderNoValueLabel,styleNoValueLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 14.0, weight: .medium)
            label?.textColor = .customBlackColor()
            label?.textAlignment = .left
            label?.numberOfLines = 1
            label?.sizeToFit()
        }
        
        colorSizeSwitch.onTintColor = .primaryColor(withAlpha:0.3)
        colorSizeSwitch.thumbTintColor = .primaryColor()
        colorSwitchLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "skuColorSwitchText")
        sizeSwitchLabel.text = LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "skuSizeSwitchText")
        colorSwitchLabel.textAlignment = .right
        sizeSwitchLabel.textAlignment = .left
        [colorSwitchLabel,sizeSwitchLabel].forEach { (label) in
            label?.font = UIFont.appFont(ofSize: 14.0, weight: .regular)
            label?.textColor = .customBlackColor()
            label?.numberOfLines = 1
            label?.sizeToFit()
        }
        
        self.skuButton.backgroundColor = .clear
        self.skuButton.setTitleColor(.primaryColor(), for: .normal)
        self.skuButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        
        self.editButton.setImage(Config.Images.shared.getImage(imageName: Config.Images.editInfoIcon), for: .normal)
        self.editButton.backgroundColor = .clear
        self.editButton.tintColor = .primaryColor()
        
        self.showOrHideColorAndSizeViews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            layout.scrollDirection = .horizontal
        }
        self.cvBackgroundView.backgroundColor = UIColor.clear //UIColor.init(rgb: 0xF6F6F6)
        self.cvBackgroundView.clipsToBounds = true
        self.cvBackgroundView.roundCorners(corners: .allCorners, radius: 8.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.dataSource = nil
        self.collectionView.reloadInputViews()
        self.collectionView.reloadData()
    }

    func showOrHideColorAndSizeViews(){
        if isSkuDataAvailable{
            self.colorSizeView.alpha = 1.0
            self.colorSizeViewHeightConstraint.constant = 150.0
            self.skuButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "viewSkuText"), for: .normal)
        }else{
            self.colorSizeView.alpha = 0.0
            self.colorSizeViewHeightConstraint.constant = 0.0
            self.skuButton.setTitle(LocalizationManager.shared.localizedString(key1: "OrderInfo", key2: "addSkuText"), for: .normal)
        }
    }
    
    func updateColorAndSizeLabel(){
        if self.skuType == .color{
            colorSizeSwitch.onTintColor = .lightGray
            colorSizeSwitch.thumbTintColor = .lightGray
            self.sizeSwitchLabel.textColor = .customBlackColor()
            self.colorSwitchLabel.textColor = .primaryColor()
            self.colorSizeSwitch.isOn = false
        }else{
            colorSizeSwitch.onTintColor = .primaryColor(withAlpha:0.3)
            colorSizeSwitch.thumbTintColor = .primaryColor()
            self.colorSwitchLabel.textColor = .customBlackColor()
            self.sizeSwitchLabel.textColor = .primaryColor()
            self.colorSizeSwitch.isOn = true
        }
        self.collectionView.reloadData()
    }
    
    func setContent(model:BasicInfoModel, target:OrderInfoVC?){
        self.isSkuDataAvailable = model.isSkuDataAvailable
        self.skuType = model.skuType
        
        self.skuButton.addTarget(target, action: #selector(target?.viewOrAddSkuButtonTapped(_:)), for: .touchUpInside)
        self.editButton.addTarget(target, action: #selector(target?.editBasicInfoButtonTapped(_:)), for: .touchUpInside)
        self.colorSizeSwitch.addTarget(target, action: #selector(target?.switchButtonTapped(_:)), for: .valueChanged)
        self.collectionView.dataSource = target
        self.collectionView.delegate = target

        if let data = model.data{
            self.buyerValueLabel.text = data.buyerName
            self.factoryValueLabel.text = data.factoryName
            if ( data.pcuName ?? "").isEmptyOrWhitespace() {
                self.pcuValueLabel.text = "-"
            }else{
                self.pcuValueLabel.text = data.pcuName
            }
            self.orderNoValueLabel.text = data.orderNo
            self.styleNoValueLabel.text = data.styleNo
        }
        self.collectionView.reloadData()
    }
}

enum SKUTypes {
    case color
    case size
}
