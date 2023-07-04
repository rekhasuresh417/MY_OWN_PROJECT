//
//  SKUAddQuantityVC.swift
//  Itohen-dms
//
//  Created by Dharma on 05/01/21.
//

import UIKit

class SKUAddQuantityVC: UIViewController {
    
    @IBOutlet var topView: UIView!
    @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    @IBOutlet var orderQtyTitleLabel: UILabel!
    @IBOutlet var orderQtyLabel: UILabel!
    @IBOutlet var tolerancePercTitleLabel: UILabel!
    @IBOutlet var tolerancePercLabel: UILabel!
    @IBOutlet var toleranceQtyTitleLabel: UILabel!
    @IBOutlet var toleranceQtyLabel: UILabel!
    @IBOutlet var totalQtyTitleLabel: UILabel!
    @IBOutlet var totalQtyLabel: UILabel!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var totalView: UIView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var totalCountLabel: UILabel!
  
    @IBOutlet var warningQuantityBackgroundView: UIView!
    @IBOutlet var warningQuantityView: UIView!
    @IBOutlet var warningQuantityTitleLabel: UILabel!
    @IBOutlet var warningQuantityMessageFirstLabel: UILabel!
    @IBOutlet var warningQuantityMessageSecondLabel: UILabel!
    @IBOutlet var updateQuantityNotNowButton: UIButton!
    @IBOutlet var updateQuantityButton: UIButton!
    
    var sections:[Section] = []
    var finalSkuData = [OrderSKUData]()
    var basicInfoData: Basic?
    
    var ccellHeight:CGFloat = 70.0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    let headerCellHeight:CGFloat = 50.0
    let ccellBottomSpace:CGFloat = 15.0
    let ccellminimumLineSpacing:CGFloat = 15.0
    
    weak var activeField: UITextField?
    var finalQuantityCount:Int = 0 {
        didSet{
            self.totalCountLabel.text = "\(finalQuantityCount)"
        }
    }
    
    var orderId:String = "0"
    var orderInfoDelegate:OrderInfoDataUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.prepareSectionsData()
        self.setupUI()
        self.checkTolerance()
        RestCloudService.shared.skuDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(SKUAddQuantityVC.keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SKUAddQuantityVC.keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "addQuantityText")
    }
    
    func setupUI() {
        self.view.backgroundColor = .appBackgroundColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .none
    
        self.warningQuantityBackgroundView.isHidden = true
        self.warningQuantityBackgroundView.backgroundColor = .customBlackColor(withAlpha: 0.7)
        self.warningQuantityView.roundCorners(corners: .allCorners, radius: 10.0)
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGesture.delegate = self
        self.warningQuantityBackgroundView.addGestureRecognizer(tapGesture)
        
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
        
        [warningQuantityTitleLabel].forEach{ (thLabel) in
            thLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            thLabel?.textColor = .customBlackColor()
            thLabel?.textAlignment = .center
            thLabel?.numberOfLines = 0
            warningQuantityTitleLabel.text = LocalizationManager.shared.localizedString(key: "quantityExceededText")
        }
        
        [warningQuantityMessageFirstLabel, warningQuantityMessageSecondLabel].forEach{ (thLabel) in
            thLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .regular)
            thLabel?.textColor = .gray
            thLabel?.textAlignment = .left
            thLabel?.numberOfLines = 0
            warningQuantityMessageFirstLabel.text = LocalizationManager.shared.localizedString(key: "quantityWarningMessageText")
            warningQuantityMessageSecondLabel.text = LocalizationManager.shared.localizedString(key: "quantityWarningConfirmMessageText")
        }
        
        [updateQuantityNotNowButton, updateQuantityButton].forEach { (theButton) in
            theButton?.layer.cornerRadius = self.updateQuantityButton.frame.height / 2.0
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            if theButton == updateQuantityNotNowButton {
                theButton?.backgroundColor = .primaryColor(withAlpha: 0.3)
                theButton?.setTitleColor(.primaryColor(), for: .normal)
            }else {
                theButton?.backgroundColor = .primaryColor()
                theButton?.setTitleColor(.white, for: .normal)
            }
        }
        
        updateQuantityNotNowButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        updateQuantityButton.setTitle(LocalizationManager.shared.localizedString(key: "confirmButtonTitleText"), for: .normal)
        
        updateQuantityNotNowButton.addTarget(self, action: #selector(self.updateQuantityNotNowButtonTapped(_:)), for: .touchUpInside)
        updateQuantityButton.addTarget(self, action: #selector(self.updateQuantityButtonTapped(_:)), for: .touchUpInside)
        
        self.totalLabel.text = LocalizationManager.shared.localizedString(key: "totalText")
        self.totalLabel.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.totalLabel.textColor = .customBlackColor()
        self.totalLabel.textAlignment = .center
        self.totalLabel.numberOfLines = 1
        self.totalLabel.sizeToFit()
        
        self.totalCountLabel.font = UIFont.appFont(ofSize: 20.0, weight: .medium)
        self.totalCountLabel.textColor = .primaryColor()
        self.totalCountLabel.textAlignment = .center
        self.totalCountLabel.numberOfLines = 1
        
        self.totalView.backgroundColor = .clear
        self.totalView.layer.borderWidth = 1.5
        self.totalView.layer.borderColor = UIColor.primaryColor().cgColor
        self.totalView.layer.cornerRadius = self.totalView.frame.height / 2.0
    }
    
    func checkTolerance(){
        if self.basicInfoData?.isToleranceRequired == "1"{
            self.topView.isHidden = false
            self.topViewHConstraint.constant = 80
            
            self.orderQtyLabel.text = self.basicInfoData?.quantity
            self.toleranceQtyLabel.text = self.basicInfoData?.toleranceVolume
            self.tolerancePercLabel.text = self.basicInfoData?.tolerancePerc
            
            if let qty = Int(self.basicInfoData?.quantity ?? "0") , let volume = Int(self.basicInfoData?.toleranceVolume ?? "0") {
                self.totalQtyLabel.text = "\(qty+volume)"
            }
            ccellHeight = 90
        }else{
            self.topView.isHidden = true
            self.topViewHConstraint.constant = 0
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
    
        if self.finalQuantityCount != Int(self.basicInfoData?.quantity ?? "0") ?? 0 {
            self.warningQuantityMessageFirstLabel.text = LocalizationManager.shared.localizedString(key: "quantityWarningMessageText").appending(" \(self.basicInfoData?.quantity ?? "0").")
            self.warningQuantityMessageSecondLabel.text = LocalizationManager.shared.localizedString(key: "quantityWarningConfirmMessageText").appending("\(self.finalQuantityCount)?")
            self.warningQuantityBackgroundView.isHidden = false

        }else{
            self.saveSKUQuantity()
        }
    }
    
    func saveSKUQuantity() {
        
        var skuData:[[String:Any]] = []
        var postData:[String:Any] = [:]
       
        self.showHud()
        
        for section in self.sections{
            for size in section.selectedSizes{
                let qty = basicInfoData?.isToleranceRequired == "0" ? size.skuQuantityOfSize : size.totalToleranceQuantity
                skuData.append([
                    "color_id" : section.colorId,
                    "size_id" : size.sizeId,
                    "quantity" : qty
                ])
            }
        }
        postData["sku"] = skuData
        postData["total_qty"] = self.finalQuantityCount
        postData["order_id"] = self.orderId
        postData["company_id"] = RMConfiguration.shared.companyId
        postData["workspace_id"] = RMConfiguration.shared.workspaceId
  
        print(postData)
        RestCloudService.shared.addOrderSKU(params: postData)
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
                                                                        skuQuantityOfSize: self.finalSkuData[i].skuQuantity ?? "",
                                                                        checkPendingQuantity: self.finalSkuData[i].skuQuantity ?? "",
                                                                        totalToleranceQuantity: self.finalSkuData[i].skuQuantity ?? ""))
                }
            }
        }
    }
    
    func updateSkuQuantity(colorId:String, sizeId:String, skuCount:String, totQty: String){
        self.finalQuantityCount = 0
        self.sections.indices.forEach { (index) in
            if (self.sections[index].colorId == colorId){
                self.sections[index].selectedSizes.indices.forEach { (modelIndex) in
                    if (self.sections[index].selectedSizes[modelIndex].sizeId == sizeId){
                        self.sections[index].selectedSizes[modelIndex].skuQuantityOfSize = skuCount
                        self.sections[index].selectedSizes[modelIndex].totalToleranceQuantity = totQty
                        self.sections[index].selectedSizes[modelIndex].checkPendingQuantity = totQty
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
  
    func toleranceCalc(quantity: String) -> String{
        var totQty: String = ""
        if self.basicInfoData?.isToleranceRequired == "1"{
            if let volume = Int(self.basicInfoData?.tolerancePerc ?? ""), let text = Int(quantity){
                let tolerance: Int = (volume * text) / 100 + text
                totQty = "\(tolerance)"
            }
        }
        return totQty
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.warningQuantityBackgroundView.isHidden = true
    }
    
    @objc func updateQuantityNotNowButtonTapped(_ sender : UIButton){
        self.warningQuantityBackgroundView.isHidden = true
    }
    
    @objc func updateQuantityButtonTapped(_ sender : UIButton){
        self.saveSKUQuantity()
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

extension SKUAddQuantityVC : UITableViewDataSource, UITableViewDelegate{
    
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

extension SKUAddQuantityVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[collectionView.tag].selectedSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath) as! SKUQuantityCollectionViewCell
        cell.sizeTextField.delegate = self
        cell.basicInfoData = self.basicInfoData
        if indexPath.row < self.sections[collectionView.tag].selectedSizes.count{
            cell.setContent(colorId: self.sections[collectionView.tag].colorId,
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

extension SKUAddQuantityVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let hasMainView = textField.superview{
            if let hasContentView = hasMainView.superview{
                if let hasCell = hasContentView.superview as? SKUQuantityCollectionViewCell{
                    
                    hasCell.tolerancePercLabel.text = "  Qty + \(basicInfoData?.tolerancePerc ?? "0") % =\(self.toleranceCalc(quantity: textField.text ?? ""))"
                    
                    // Update Sku count to the relevant size model
                    self.updateSkuQuantity(colorId: hasCell.colorId, sizeId: hasCell.sizeId, skuCount: textField.text ?? "0", totQty: self.toleranceCalc(quantity: textField.text ?? ""))
                    
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

extension SKUAddQuantityVC: UIGestureRecognizerDelegate{
    // MARK: UIGestureRecognizerDelegate methods, You need to set the delegate of the recognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: warningQuantityView) == true{
            return false
         }
         return true
    }
}

extension SKUAddQuantityVC: RCSKUDelegate {
  
    func didReceiveAddSKUQuanity(message: String){
        self.hideHud()
            UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                let vc = self.navigationController?.viewControllers.first(where: { (controller) -> Bool in
                    return controller.isKind(of: OrderInfoVC.self)
                })
                if vc != nil{
                    self.orderInfoDelegate = vc as? OrderInfoDataUpdateDelegate
                    self.orderInfoDelegate?.updateOrderInfoData(.basic, orderInfoData: nil)
                    RestCloudService.shared.orderInfoDelegate = vc as? RCOrderInfoDelegate
                    self.navigationController?.popToViewController(vc!, animated: true)
                }
            }
        })
    }
    
    func didFailedToReceiveAddSKUQuanity(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
}
