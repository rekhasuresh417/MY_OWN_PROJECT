//
//  SKUViewVC.swift
//  Itohen-dms
//
//  Created by Dharma on 05/01/21.
//

import UIKit

class SKUViewVC: UIViewController {
    
    @IBOutlet var skuView:UIView!
    @IBOutlet var addSkuButton:UIButton!
    lazy var dataTable = makeDataTable(skuData: skuData)
    lazy var productionDataTable = makeDataTable(skuData: productionSKUData)

    @IBOutlet var topView: UIView!
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var patternImageBackgroundView: UIView!
    @IBOutlet var patternImageView: UIImageView!
    @IBOutlet var patternNameLabel: UILabel!
    @IBOutlet var productionDateLabel: UILabel!
    @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    
    @IBOutlet var productionSKUButton: UIButton!
    @IBOutlet var orderSKUButton: UIButton!
    
    private var buttons: [UIButton] {
        return [productionSKUButton, orderSKUButton]
    }
    
    var colorSizeActualValue: [OrderSKUData] = []
    var orderId:String = "0"
    var skuData:[OrderSKUData] = []
    var productionSKUData:[OrderSKUData] = []
 
    var involvedColor: [String] = []
    var involvedSize: [String] = []
    
    var isFromProduction: Bool = false
    var model:[SkuTableData] = []
    var sizeModel:[String:SizeData] = [:]
    var basicInfoData: Basic?
    
    //var totalQuantity:String = "0"
    
    var getCurrentSection: String = ""
    var prodDate:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "skuViewTitle")
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .appBackgroundColor()
        self.skuView.backgroundColor = .clear
      
        self.addSkuButton.layer.cornerRadius = self.addSkuButton.frame.height / 2.0
        self.addSkuButton.setTitle(LocalizationManager.shared.localizedString(key: "addSkuDetailsButtonText"), for: .normal)
        self.addSkuButton.setTitleColor(.white, for: .normal)
        self.addSkuButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.addSkuButton.addTarget(self, action: #selector(self.addSkuButtonTapped(_:)), for: .touchUpInside)
   
        self.topViewHConstraint.constant = isFromProduction ? 150 : 0
        self.topView.isHidden = isFromProduction ? false : true
      
        if isFromProduction{
            self.addSkuButton.isHidden = true
            skuView.addSubview(productionDataTable)
            
            NSLayoutConstraint.activate([
                productionDataTable.topAnchor.constraint(equalTo: skuView.layoutMarginsGuide.topAnchor),
                productionDataTable.leadingAnchor.constraint(equalTo: skuView.leadingAnchor),
                productionDataTable.bottomAnchor.constraint(equalTo: skuView.layoutMarginsGuide.bottomAnchor),
                productionDataTable.trailingAnchor.constraint(equalTo: skuView.trailingAnchor),
            ])
            self.setProductionData()
        }else{
            self.addSkuButton.isHidden = false
            skuView.addSubview(dataTable)
            
            NSLayoutConstraint.activate([
                dataTable.topAnchor.constraint(equalTo: skuView.layoutMarginsGuide.topAnchor),
                dataTable.leadingAnchor.constraint(equalTo: skuView.leadingAnchor),
                dataTable.bottomAnchor.constraint(equalTo: skuView.layoutMarginsGuide.bottomAnchor),
                dataTable.trailingAnchor.constraint(equalTo: skuView.trailingAnchor),
            ])
        }
    }
    
    func setProductionData() {
        
        [patternNameLabel, productionDateLabel].forEach { (theLabel) in
            theLabel?.textAlignment = .left
            if theLabel == patternNameLabel{
                theLabel?.textColor = .customBlackColor()
                theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
            }else if theLabel == productionDateLabel{
                theLabel?.textColor = .gray
                theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            }
        }
        
        self.patternImageBackgroundView.layer.cornerRadius = self.patternImageBackgroundView.frame.height/2
        self.patternImageBackgroundView.backgroundColor = .primaryColor(withAlpha: 0.3)
        self.patternImageView.backgroundColor = .clear
        
        self.productionSKUButton.backgroundColor = .primaryColor()
        self.productionSKUButton.setTitle(LocalizationManager.shared.localizedString(key: "addSkuDetailsButtonText"), for: .normal)
        self.productionSKUButton.setTitleColor(.white, for: .normal)
        self.productionSKUButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        
        self.secondView.layer.borderColor = UIColor.lightGray.cgColor
        self.secondView.layer.borderWidth = 1
       
        productionSKUButton.isSelected = true

        buttons.forEach { button in
               button.setTitleColor(.white, for: .selected)
               button.setTitleColor(.primaryColor(), for: .normal)
               button.backgroundColor = button.isSelected ? UIColor.primaryColor() : .white
            button.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            if button == productionSKUButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "productionSKUButtonText"), for: .normal)
            }else{
                button.setTitle(LocalizationManager.shared.localizedString(key: "orderSKUButtonText"), for: .normal)
            }
            
           }
        if self.getCurrentSection == "Cut"{
            self.getCurrentSection = "Cutting"
            self.patternImageView.image = UIImage (named: Config.Images.cuttingIcon)
        }else if self.getCurrentSection == "Sew"{
            self.getCurrentSection = "Sewing"
            self.patternImageView.image = UIImage (named: Config.Images.sewingIcon)
        }else if self.getCurrentSection == "Pack"{
            self.getCurrentSection = "Packing"
            self.patternImageView.image = UIImage (named: Config.Images.packingIcon)
        }
        self.patternNameLabel.text = self.getCurrentSection
        self.productionDateLabel.text = self.prodDate
    }
 
    @IBAction func buttonAction(_ sender: UIButton) {

        UIView.animate(withDuration: 0.0) { [self] in
       
            self.buttons.forEach { button in
                button.isSelected.toggle()
                button.setTitleColor(.white, for: .selected)
                button.setTitleColor(.primaryColor(), for: .normal)
                button.backgroundColor = button.isSelected ? UIColor.primaryColor() : .white
            }
       
            if productionDataTable.isDescendant(of: self.skuView) {
                productionDataTable.removeFromSuperview()
                self.skuView.addSubview(dataTable)
                
                NSLayoutConstraint.activate([
                    dataTable.topAnchor.constraint(equalTo: skuView.layoutMarginsGuide.topAnchor),
                    dataTable.leadingAnchor.constraint(equalTo: skuView.leadingAnchor),
                    dataTable.bottomAnchor.constraint(equalTo: skuView.layoutMarginsGuide.bottomAnchor),
                    dataTable.trailingAnchor.constraint(equalTo: skuView.trailingAnchor),
                ])
               
            } else {
                dataTable.removeFromSuperview()
                self.skuView.addSubview(productionDataTable)
             
                NSLayoutConstraint.activate([
                    productionDataTable.topAnchor.constraint(equalTo: skuView.layoutMarginsGuide.topAnchor),
                    productionDataTable.leadingAnchor.constraint(equalTo: skuView.leadingAnchor),
                    productionDataTable.bottomAnchor.constraint(equalTo: skuView.layoutMarginsGuide.bottomAnchor),
                    productionDataTable.trailingAnchor.constraint(equalTo: skuView.trailingAnchor),
                ])
            }
            
            if self.productionSKUButton.isSelected {
                print("productionSKU selected")
            } else {
              print("orderSKU selected")
            }
           
          //  self.dataTable = self.makeDataTable()
        }
    }
    
    @objc func addSkuButtonTapped(_ sender: UIButton) {
        if  self.appDelegate().userDetails.userRole == .admin ||  self.appDelegate().userDetails.userRole == .manager{
            // Full access
            if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addSKU) as? SKUAddVC {
                vc.orderId = self.orderId
                vc.finalSkuData = self.skuData
                vc.skuData = self.skuData
                vc.involvedColor = self.involvedColor
                vc.involvedSize = self.involvedSize
                vc.basicInfoData = self.basicInfoData
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
        }
    }
    
    func makeDataTable(skuData: [OrderSKUData]) -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: data(skuData: skuData),
            headerTitles: extractedFunc(),
            options: makeOptions()
        )
        dataTable.collectionView.backgroundColor = .clear
        dataTable.backgroundColor = .clear
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        return dataTable
    }
    
    func makeOptions() -> DataTableConfiguration {
        var options = DataTableConfiguration()
        options.shouldContentWidthScaleToFillFrame = true
        options.defaultOrdering = DataTableColumnOrder(index: 0, order: .hidden)
        options.fixedColumns = DataTableFixedColumnType(leftColumns: 1, rightColumns: 1)
        options.shouldShowSearchSection = false
        options.shouldShowFooter = false
        return options
    }
    
    func columnHeaders() -> [String] {
        // Adding header section
        var skuHeaderString:[String] = [LocalizationManager.shared.localizedString(key: "colorAndSizeText")]
        for dict in sizeModel{
            print(dict)
            skuHeaderString.append(dict.value.sizeTitle)
        }
        skuHeaderString.append("b/\(LocalizationManager.shared.localizedString(key: "totalText"))")
        return skuHeaderString
    }
    
    func data(skuData: [OrderSKUData]) -> [[DataTableValueType]] {
        //This would be your json object
        var dataSet: [[Any]] = prepareSkuData(skuData: skuData)
        for _ in 0..<0 {
            dataSet += prepareSkuData(skuData: skuData)
        }
        
        return dataSet.map {
            $0.compactMap(DataTableValueType.init)
        }
    }
    
    fileprivate func extractedFunc() -> [String] {
        return columnHeaders()
    }
    
    func prepareSkuData(skuData: [OrderSKUData]) -> [[Any]] {
        model = []
        sizeModel = [:]
        for data in skuData{
            let cIndex = model.indices.first { (index) in
                return model[index].colorId == data.colorID
            }
            
            if let i = cIndex{
                if let skuQuantity = Int(data.skuQuantity ?? ""){
                    model[i].totalColorQuantity = model[i].totalColorQuantity + skuQuantity
                    
                    let sIndex = model[i].sizeData.indices.first { (index) in
                        return model[i].sizeData[index].sizeId == data.sizeID
                    }
                    
                    if let j = sIndex{
                        model[i].sizeData[j].sizeQuantity = model[i].sizeData[j].sizeQuantity + skuQuantity
                        if let keyValue = sizeModel[data.sizeID ?? ""]{
                            sizeModel[data.sizeID ?? ""]?.sizeQuantity = keyValue.sizeQuantity + skuQuantity
                        }else{
                            sizeModel[data.sizeID ?? ""] = SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: skuQuantity)
                        }
                    }else{
                        model[i].sizeData.append(SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: skuQuantity))
                        if let keyValue = sizeModel[data.sizeID ?? ""]{
                            sizeModel[data.sizeID ?? ""]?.sizeQuantity = keyValue.sizeQuantity + skuQuantity
                        }else{
                            sizeModel[data.sizeID ?? ""] = SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: skuQuantity)
                        }
                    }
                }
            }else{
                if let skuQuantity = Int(data.skuQuantity ?? ""){
                    model.append(SkuTableData(colorTitle: data.colorTitle ?? "", colorId: data.colorID ?? "", totalColorQuantity: skuQuantity, sizeData: [SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: skuQuantity)]))
                    if let keyValue = sizeModel[data.sizeID ?? ""]{
                        sizeModel[data.sizeID ?? ""]?.sizeQuantity = keyValue.sizeQuantity + skuQuantity
                    }else{
                        sizeModel[data.sizeID ?? ""] = SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: skuQuantity)
                    }
                }else{
                    model.append(SkuTableData(colorTitle: data.colorTitle ?? "", colorId: data.colorID ?? "", totalColorQuantity: 0, sizeData: [SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: 0)]))
                    if let keyValue = sizeModel[data.sizeID ?? ""]{
                        sizeModel[data.sizeID ?? ""]?.sizeQuantity = keyValue.sizeQuantity + 0
                    }else{
                        sizeModel[data.sizeID ?? ""] = SizeData(sizeTitle: data.sizeTitle ?? "", sizeId: data.sizeID ?? "", sizeQuantity: 0)
                    }
                }
                
            }
        }
        print(model)
        print(sizeModel)
        
        var skuArrayString:[[String]] = []
        
        for i in 0..<model.count{
            
            var skuString:[String] = []
            skuString.append("t/" + model[i].colorTitle) // here the `t/` is used to change only the text color of particular row in `DataCell.swift` file
            
            for dict in sizeModel{
                var count:Int = 0
                for size in model[i].sizeData{
                    if size.sizeId == dict.key{
                        count = size.sizeQuantity
                        break
                    }
                }
                skuString.append("\(count)")
            }
            skuString.append("b/\(model[i].totalColorQuantity)") // here the `b/` is used to change both text & background color of particular row in `DataCell.swift` file
            skuArrayString.append(skuString)
        }
        
        // Adding footer section
        var skuFooterString:[String] = []
        skuFooterString.append("b/\(LocalizationManager.shared.localizedString(key: "totalText"))") // same like above
        var totalCount:Int = 0
        for dict in sizeModel{
            totalCount = totalCount + dict.value.sizeQuantity
            skuFooterString.append("b/\(dict.value.sizeQuantity)") // same like above
        }
        skuFooterString.append("b/\(totalCount)") // same like above
        skuArrayString.append(skuFooterString)
        
        // Final sku table data
        print(skuArrayString)
        
        return skuArrayString
    }
}

struct SkuTableData {
    var colorTitle:String
    var colorId:String
    var totalColorQuantity:Int
    var sizeData:[SizeData]
}

struct SizeData {
    var sizeTitle:String
    var sizeId:String
    var sizeQuantity:Int
}
