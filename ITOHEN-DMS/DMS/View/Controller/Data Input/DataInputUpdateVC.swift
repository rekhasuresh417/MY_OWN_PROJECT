//
//  DataInputUpdateVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 21/10/22.
//

import UIKit

class DataInputUpdateVC: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var addQuantityButton: UIButton!
    @IBOutlet var viewSKUButton: UIButton!
    @IBOutlet var skuView: UIView!
    
    @IBOutlet var productionTypeLabel: UILabel!
    @IBOutlet var delayedProductionType: UILabel!
    @IBOutlet var productionTypeImageView: UIImageView!
    @IBOutlet var productionDateTitleLabel: UILabel!
    @IBOutlet var productionDateTextLabel: UILabel!
    @IBOutlet var dataInputBreakUpView: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view4: UIView!
    @IBOutlet var dataInputBreakupViewHConstrint: NSLayoutConstraint!
    @IBOutlet var delayTextLabel: UILabel!
    @IBOutlet var delayTextView: UIView!

    @IBOutlet var sizeTitleLabel: UILabel!
    @IBOutlet var sizeTextLabel: UILabel!
    @IBOutlet var totalSizeTitleLabel: UILabel!
    @IBOutlet var totalSizeTextLabel: UILabel!
    @IBOutlet var updatedSizeTitleLabel: UILabel!
    @IBOutlet var updatedSizeTextLabel: UILabel!
    @IBOutlet var pendingSizeTitleLabel: UILabel!
    @IBOutlet var pendingSizeTextLabel: UILabel!
    
    @IBOutlet var accomplishedBackgroundView: UIView!
    @IBOutlet var areYouSureTextLabel: UILabel!
    @IBOutlet var accomplishedCenterView: UIView!
    @IBOutlet var warningImageView: UIImageView!
    @IBOutlet var accomplishedWaringTextLabel: UILabel!
    @IBOutlet var accomplishedOkButton: UIButton!
    @IBOutlet var accomplishedCancelButton: UIButton!
       
    /// SKU Table
    lazy var dataTable = makeDataTable(skuData: viewSkuData)
    var model:[SkuTableData] = []
    var sizeModel:[String:SizeData] = [:]
    
    var sectionButtons:[UIButton] = []
    var sections:[Section] = []
    var finalSkuData = [SKUData]()
    var tempSkuData = [SKUData]()
    var viewSkuData = [SKUData]()
    var basicInfoData: Basic?
    
    var dataUpdateDelegate: ProductionDataUpdateDelegate?
    var isExcess: Bool = false
    var knobChart: KnobChart?
    
    var ccellHeight:CGFloat = 70.0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    let headerCellHeight:CGFloat = 50.0
    let ccellBottomSpace:CGFloat = 15.0
    let ccellminimumLineSpacing:CGFloat = 15.0
    
    weak var activeField: UITextField?
    var finalQuantityCount: Int = 0
    var productionType: String = ""
    var targetValue: String = "0"
    var selectedDate: Date?
    var isView: Bool = false
    var orderId:String = "0"
    var isDelayedCompletion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.getSKUData()
        RestCloudService.shared.productionDelegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(DataInputUpdateVC.keyboardDidShow),
//            name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(DataInputUpdateVC.keyboardWillBeHidden),
//            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.skuView.isHidden = true
        self.tableView.isHidden = false
        self.title = LocalizationManager.shared.localizedString(key: "addQuantityText")
    }
    
    func setupUI() {
        self.view.backgroundColor = .appBackgroundColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .none
   
        if productionType == Config.Text.cut{
            self.productionTypeImageView.image = UIImage.init(named: Config.Images.cuttingIcon)
            self.productionTypeLabel.text = LocalizationManager.shared.localizedString(key: "cuttingText")
            self.delayedProductionType.text = LocalizationManager.shared.localizedString(key: "cuttingText")
        }else if productionType == Config.Text.sew{
            self.productionTypeImageView.image = UIImage.init(named: Config.Images.sewingIcon)
            self.productionTypeLabel.text = LocalizationManager.shared.localizedString(key: "sewingText")
            self.delayedProductionType.text = LocalizationManager.shared.localizedString(key: "sewingText")
        }else if productionType == Config.Text.pack{
            self.productionTypeImageView.image = UIImage.init(named: Config.Images.packingIcon)
            self.productionTypeLabel.text = LocalizationManager.shared.localizedString(key: "packingText")
            self.delayedProductionType.text = LocalizationManager.shared.localizedString(key: "packingText")
        }
        
        delayTextView.backgroundColor = .clear
        productionTypeImageView.tintColor = .primaryColor()
        delayedProductionType.textColor = .primaryColor()
     
        if knobChart?.pendingQuantity == 0{
           if isDelayedCompletion {
               delayTextLabel.textColor = .delyCompletionColor()
               productionTypeImageView.tintColor = .delyCompletionColor()
               delayedProductionType.textColor = .delyCompletionColor()
               delayTextLabel.text = LocalizationManager.shared.localizedString(key: "delayedCompletionTitleText")
            }else{
                delayTextLabel.textColor = .completedColor()
                productionTypeImageView.tintColor = .completedColor()
                delayedProductionType.textColor = .completedColor()
                delayTextLabel.text = LocalizationManager.shared.localizedString(key: "compltdTitleText")
            }
            
            delayTextView.isHidden = false
            productionTypeLabel.isHidden = true
            updateButton.isUserInteractionEnabled = false
            updateButton.alpha = 0.3
        }else{
            updateButton.isUserInteractionEnabled = true
            updateButton.alpha = 1.0
            
            if isExcess && knobChart?.pendingQuantity ?? 0 > 0{
                delayTextLabel.textColor = .delayedColor()
                productionTypeImageView.tintColor = .delayedColor()
                delayedProductionType.textColor = .delayedColor()
                delayTextLabel.text = LocalizationManager.shared.localizedString(key: "delayedTitleText")

                delayTextView.isHidden = false
                productionTypeLabel.isHidden = true
         
            }else{
                delayTextView.isHidden = true
                productionTypeLabel.isHidden = false
                productionTypeLabel.textColor = .primaryColor()
                productionTypeImageView.tintColor = .primaryColor()
            }
        }
   
        self.productionDateTitleLabel.text = LocalizationManager.shared.localizedString(key: "dateText")
        self.productionDateTextLabel.text = DateTime.convertDateFormater(DateTime.formatDate(date: selectedDate, dateFormat: Date.simpleDateFormat),
                                                                         currentFormat: Date.simpleDateFormat,
                                                                         newFormat: RMConfiguration.shared.dateFormat)
        
        self.sectionButtons = [addQuantityButton, viewSKUButton]
        self.addQuantityButton.tag = 1
        self.viewSKUButton.tag = 2
        self.sectionButtons.forEach { (button) in
            button.titleLabel?.font = .appFont(ofSize: 15.0, weight: .medium)
            button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
            button.backgroundColor = .white
            
            if button == addQuantityButton{
                button.setTitleColor(.primaryColor(), for: .normal)
                button.setTitle(LocalizationManager.shared.localizedString(key: "addQuantityText"), for: .normal)
            }else if button == viewSKUButton{
                button.setTitleColor(.darkGray, for: .normal)
                button.setTitle(LocalizationManager.shared.localizedString(key: "viewSKUDataText"), for: .normal)
            }
        }
        
        self.updateButton.layer.cornerRadius = self.updateButton.frame.height / 2.0
        self.updateButton.setTitle(LocalizationManager.shared.localizedString(key: "updateButtonText"), for: .normal)
        self.updateButton.setTitleColor(.white, for: .normal)
        self.updateButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.updateButton.addTarget(self, action: #selector(self.updateButtonTapped(_:)), for: .touchUpInside)
        
        self.dataInputBreakUpView.isHidden = true
        self.dataInputBreakupViewHConstrint.constant = 0.0
        view1.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        view4.roundCorners(corners: [.topRight, .bottomRight], radius: 10)
        stackView.roundCorners(corners: .allCorners, radius: 10)
        dataInputBreakUpView.roundCorners(corners: .allCorners, radius: 10)
        
        totalSizeTitleLabel.text = LocalizationManager.shared.localizedString(key: "totalText")
        updatedSizeTitleLabel.text = LocalizationManager.shared.localizedString(key: "updatedText")
        pendingSizeTitleLabel.text = LocalizationManager.shared.localizedString(key: "pendingText")
        
        /// SKU table
        skuView.addSubview(dataTable)
        
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: skuView.layoutMarginsGuide.topAnchor),
            dataTable.leadingAnchor.constraint(equalTo: skuView.leadingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: skuView.layoutMarginsGuide.bottomAnchor),
            dataTable.trailingAnchor.constraint(equalTo: skuView.trailingAnchor),
        ])
        
        /// Accomplished Task
        self.accomplishedBackgroundView.isHidden = true
        self.accomplishedBackgroundView.backgroundColor = .customBlackColor(withAlpha: 0.7)
        self.accomplishedCenterView.roundCorners(corners: .allCorners, radius: 10.0)
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGesture.delegate = self
        self.accomplishedBackgroundView.addGestureRecognizer(tapGesture)
    
        [areYouSureTextLabel, accomplishedWaringTextLabel].forEach{ (thLabel) in
            thLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            thLabel?.textColor = .customBlackColor()
            thLabel?.textAlignment = .center
            thLabel?.numberOfLines = 0
            accomplishedWaringTextLabel.text = "\(LocalizationManager.shared.localizedString(key: "accomplishedTaskText")) \(self.productionTypeLabel.text ?? "") \(LocalizationManager.shared.localizedString(key: "dataInputTitleText"))!"
            
            if thLabel == self.areYouSureTextLabel{
                thLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .bold)
                areYouSureTextLabel.text = "\(LocalizationManager.shared.localizedString(key: "areYouSureText"))"
            }
        }
    
        [accomplishedOkButton, accomplishedCancelButton].forEach { (theButton) in
            theButton?.layer.cornerRadius = self.accomplishedOkButton.frame.height / 2.0
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            if theButton == accomplishedCancelButton {
                theButton?.backgroundColor = .primaryColor(withAlpha: 0.3)
                theButton?.setTitleColor(.primaryColor(), for: .normal)
            }else {
                theButton?.backgroundColor = .primaryColor()
                theButton?.setTitleColor(.white, for: .normal)
            }
        }
        
        accomplishedCancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        accomplishedOkButton.setTitle(LocalizationManager.shared.localizedString(key: "okButtonText"), for: .normal)
        
        accomplishedCancelButton.addTarget(self, action: #selector(self.accomplishedCancelButtonTapped(_:)), for: .touchUpInside)
        accomplishedOkButton.addTarget(self, action: #selector(self.accomplishedOkButtonTapped(_:)), for: .touchUpInside)
}

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topView.addBottomShadow()
        self.dataInputBreakUpView.applyLightShadow()
    }
    
    func getSKUData() {

        self.showHud()
        let params:[String:Any] = [ "order_id": self.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId,
                                    "type_of_production": self.productionType,
                                    "sku_date":  DateTime.formatDate(date: selectedDate, dateFormat: Date.simpleDateFormat)]
        print(params)
        RestCloudService.shared.getSKUData(params: params)
    }
    
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        self.sectionButtons.forEach { (button) in
            button.backgroundColor = .white
            button.setTitleColor((button.tag == sender.tag) ? .primaryColor() : .darkGray, for: .normal)
       }
        
        switch sender.tag {
        case 1:
           self.finalSkuData = tempSkuData
            self.updateButton.isHidden = false
            self.isView = false
            self.skuView.isHidden = true
            self.tableView.isHidden = false
        case 2:
            self.finalSkuData = viewSkuData
            self.updateButton.isHidden = true
            self.isView = true
            self.skuView.isHidden = false
            self.tableView.isHidden = true
        default:
            print("Unknown language")
            return
        }
        self.prepareSectionsData()
    }
    
    @objc func updateButtonTapped(_ sender: UIButton) {
        
        if checkAccomplishedTask() {
            self.accomplishedBackgroundView.isHidden = false
            return
        }
        self.saveSKUQuantity(isAccomplished: "0")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.accomplishedBackgroundView.isHidden = true
    }
 
    @objc func accomplishedCancelButtonTapped(_ sender : UIButton){
        self.accomplishedBackgroundView.isHidden = true
    }
    
    @objc func accomplishedOkButtonTapped(_ sender : UIButton){
        self.saveSKUQuantity(isAccomplished: "1")
    }
    
    func saveSKUQuantity(isAccomplished: String) {
   
        var skuData:[[String:Any]] = []
        var postData:[String:Any] = [:]
       
        self.showHud()
        
        for section in self.sections{
            for size in section.selectedSizes{
                print(size.skuQuantityOfSize)
                
                var qty = size.skuQuantityOfSize // totalToleranceQuantity
                qty = qty == "" ? "0" : qty
                skuData.append([
                    "color_id" : section.colorId,
                    "size_id" : size.sizeId,
                    "quantity" : qty
                ])
            }
        }
        postData["data"] = skuData
        postData["date"] = DateTime.formatDate(date: selectedDate, dateFormat: Date.simpleDateFormat)
        postData["order_id"] = self.orderId
        postData["target_value"] = self.targetValue == "Delay" ? "0" : self.targetValue
        postData["company_id"] = RMConfiguration.shared.companyId
        postData["workspace_id"] = RMConfiguration.shared.workspaceId
        postData["user_id"] = RMConfiguration.shared.userId
        postData["staff_id"] = RMConfiguration.shared.staffId
        postData["type_of_production"] = self.productionType
        postData["is_order_accomplished"] = isAccomplished

        print(postData)
        RestCloudService.shared.addInputData(params: postData,
                                             isExcess: self.isExcess)
    }
  
    func checkAccomplishedTask() -> Bool{
        var qty: Int = 0
        for section in self.sections{
            for size in section.selectedSizes{
                qty = qty + ((Int(size.skuQuantityOfSize) ?? 0) - (Int(size.checkPendingQuantity) ?? 0))
            }
        }
        return qty + (knobChart?.completedQuantity ?? 0) == knobChart?.totalQuantity ? true : false
    }
    
    func prepareSectionsData(){
        
        self.sections.removeAll()
        self.finalQuantityCount = 0
        
        //create a section for each color without sizes.
        for data in self.finalSkuData {
            if sections.contains(where: {$0.colorId == data.colorID}) == false{
                self.sections.append(Section(colorName: data.colorTitle ?? "",
                                             colorId: data.colorID ?? "",
                                             selectedSizes: [],
                                             totalSkuQuantityOfSection: "0"))
            }
            if let skuQuantity = Int(data.skuQuantity ?? ""){
                finalQuantityCount = finalQuantityCount + skuQuantity
            }
        }
        
        // Append sizes to relavent color section
        for i in 0..<self.finalSkuData.count{
            self.sections.indices.forEach { (index) in
                if (self.sections[index].colorId == self.finalSkuData[i].colorID){
                    self.sections[index].selectedSizes.append(SizeModel(sizeId: self.finalSkuData[i].sizeID ?? "",
                                                                        sizeName: self.finalSkuData[i].sizeTitle ?? "",
                                                                        skuQuantityOfSize: self.finalSkuData[i].todayUpdatedQty ?? "",
                                                                        checkPendingQuantity: self.finalSkuData[i].todayUpdatedQty ?? "",
                                                                        totalToleranceQuantity: self.finalSkuData[i].todayUpdatedQty ?? "",
                                                                        totalQty: self.finalSkuData[i].skuQuantity ?? "0",
                                                                        updatedQty: self.finalSkuData[i].updatedQuantity ?? "0",
                                                                        pendingQty: self.finalSkuData[i].pendingQty ?? "0"))
                }
            }
        }
       self.tableView.reloadData()
    }
    
    private func updateSkuQuantity(colorId:String, sizeId:String, skuCount:String, totQty: String){
        self.finalQuantityCount = 0
        self.sections.indices.forEach { (index) in
            if (self.sections[index].colorId == colorId){
                self.sections[index].selectedSizes.indices.forEach { (modelIndex) in
                    if (self.sections[index].selectedSizes[modelIndex].sizeId == sizeId){
                        self.sections[index].selectedSizes[modelIndex].skuQuantityOfSize = skuCount
                        self.sections[index].selectedSizes[modelIndex].totalToleranceQuantity = totQty
                        return
                    }
                }
            }
            
            // Update overall Sku quantity
            if let totalSkuQuantityOfSection = Int(sections[index].totalSkuQuantityOfSection){
                self.finalQuantityCount = finalQuantityCount + totalSkuQuantityOfSection
            }
        }
    }
  
    func dataInputCalc(previousQty: String, quantity: String) -> String{
        return  "\((Int(previousQty) ?? 0) + (Int(quantity) ?? 0))"
    }
 
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 20.0 // Padding between the bottom of the view and the top of the keyboard
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        guard let activeField = activeField, let keyboardHeight = keyboardSize?.height else { return }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + verticalPadding, right: 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        let activeRect = activeField.convert(activeField.bounds, to: self.tableView)
        self.tableView.scrollRectToVisible(activeRect, animated: true)
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
}

extension DataInputUpdateVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // For section 1, the total count is items count plus the number of headers
        var count = sections.count
        
        for _ in sections {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SKUQuantityHeaderTableViewCell
            cell.toggleButton.tag = section
            cell.toggleButton.addTarget(self, action: #selector(self.toggleCollapse), for: .touchUpInside)
            cell.indexPath = indexPath
            cell.setContent(section: sections[section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tcell") as! SKUQuantityFieldsTableViewCell
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.tag = section
            cell.setContent(section: sections[section])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate the real section index and row index
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        // Header has fixed height
        if row == 0 {
            return self.headerCellHeight
        }
        
        let noOfSizeItems = CGFloat(sections[section].selectedSizes.count)
        let noOfRows = (noOfSizeItems <= 2.0) ? 1.0 : (noOfSizeItems/2.0).rounded(.awayFromZero)
        return sections[section].collapsed ? 0.0 : (noOfRows * self.ccellHeight) + (noOfRows * self.ccellminimumLineSpacing)
        
        //return sections[section].collapsed ? 0 : 300.0
    }
    
    //
    // MARK: - Event Handlers
    //
    @objc func toggleCollapse(_ sender: UIButton) {
        let section = sender.tag
        let collapsed = sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = !collapsed
        
        let indices = getHeaderIndices()
        
        let start = indices[section]
        /* 1 denotes 1 collectionview for each section */
        let end = start + 1 //sections[section].selectedSizes.count
        
        tableView.beginUpdates()
        for i in start ..< end + 1 {
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    //
    // MARK: - Helper Functions
    //
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for _ in sections {
            indices.append(index)
            index += 2 //section.selectedSizes.count + 1
        }
        
        return indices
    }

}

extension DataInputUpdateVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[collectionView.tag].selectedSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath) as! ProductionSKUCollectionViewCell
        cell.sizeTextField.delegate = self
        cell.basicInfoData = self.basicInfoData
        cell.isView = self.isView
        if indexPath.row < self.sections[collectionView.tag].selectedSizes.count{
            cell.setContent(colorId: self.sections[collectionView.tag].colorId,
                            colorName: self.sections[collectionView.tag].colorName,
                            model: self.sections[collectionView.tag].selectedSizes[indexPath.row],
                            target: self)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow =  2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing *   CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize.init(width: CGFloat(size), height: self.ccellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.ccellminimumLineSpacing
    }
}

extension DataInputUpdateVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        
        self.dataInputBreakUpView.isHidden = false
        self.dataInputBreakupViewHConstrint.constant = 50.0
        
        if let hasMainView = textField.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview as? ProductionSKUCollectionViewCell{
                    sizeTitleLabel.text = hasCell.colorName
                    sizeTextLabel.text = hasCell.sizeModel?.sizeName
                    totalSizeTextLabel.text = hasCell.sizeModel?.totalQty
                    updatedSizeTextLabel.text = hasCell.sizeModel?.updatedQty
                    pendingSizeTextLabel.text = hasCell.sizeModel?.pendingQty
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let hasMainView = textField.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview as? ProductionSKUCollectionViewCell{
                 
                    self.updateSkuQuantity(colorId: hasCell.colorId, sizeId: hasCell.sizeId, skuCount: textField.text ?? "0", totQty: self.dataInputCalc(previousQty: hasCell.sizeModel?.skuQuantityOfSize ?? "", quantity: textField.text ?? ""))
                    
                    // Reload relevant tableview indexpath to update total no of Sku of section
                    if let hasCV = hasCell.superview as? UICollectionView{
                        if let cell = hasCV.superview?.superview?.superview as? SKUQuantityFieldsTableViewCell{
                            let indexPath = tableView.indexPath(for: cell)
                            if let hasIndexPath = indexPath, hasIndexPath.row - 1 >= 0{
                                tableView.beginUpdates()
                                tableView.reloadRows(at: [IndexPath(row: hasIndexPath.row - 1, section: hasIndexPath.section)], with: .automatic)
                                tableView.endUpdates()
                            }
                        }
                    }
                }
            }
        }
        
        activeField = nil
        self.dataInputBreakUpView.isHidden = true
        self.dataInputBreakupViewHConstrint.constant = 0.0
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if String().checkCharactersSetNumbersOnly(string: string) == false{
            return false // failed in character validation
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DataInputUpdateVC: RCProductionDelegate {
  
    /// Get sku data  delegates
    func didReceiveGetSKUData(data: [SKUData]?){
        self.hideHud()
        if let skuData = data{
            self.finalSkuData = skuData
            self.tempSkuData = skuData
            self.prepareSectionsData()
        }
    }
    
    func didFailedToReceiveGetSKUData(errorMessage: String){
        self.hideHud()
    }
    
    /// Add data  input delegates
    func didReceiveAddInputData(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                self.dataUpdateDelegate?.reloadProductionData()
            }
        })
    }
    
    func didFailedToReceiveAddInputData(errorMessage: String){
        self.hideHud()
        
        if errorMessage.contains("Actual quantity for Color"){
            
            let message = errorMessage.components(separatedBy: "-")
            let colorArr = message[1].components(separatedBy: " ")
            let color = colorArr[1]
            let sizeArr = message[2].components(separatedBy: " ")
            let size = sizeArr[1]
            
            let localizedString = LocalizationManager.shared.localizedString(key: "exceededTotalQuantity")
            var msg: String = ""
            
            
            if productionType == Config.Text.sew{
                msg = String(format: localizedString, color, size, Config.Text.cut)
            }else if productionType == Config.Text.pack{
                msg = String(format: localizedString, color, size, Config.Text.sew)
            }else{
                msg = String(format: localizedString, color, size, "")
            }
            UIAlertController.showAlert(message: msg, target: self)
        }else{
            UIAlertController.showAlert(message: errorMessage, target: self)
        }
        
    }
}

/// SKU Table
extension DataInputUpdateVC{
    func makeDataTable(skuData: [SKUData]) -> SwiftDataTable {
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
    
    func data(skuData: [SKUData]) -> [[DataTableValueType]] {
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
    
    func prepareSkuData(skuData: [SKUData]) -> [[Any]] {
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

extension DataInputUpdateVC: UIGestureRecognizerDelegate{
    // MARK: UIGestureRecognizerDelegate methods, You need to set the delegate of the recognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: accomplishedCenterView) == true{
            return false
         }
         return true
    }
}
