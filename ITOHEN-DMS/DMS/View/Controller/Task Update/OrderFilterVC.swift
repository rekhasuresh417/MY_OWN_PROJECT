//
//  OrderFilterVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

class OrderFilterVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var field1TextField:MDCOutlinedTextField!
    @IBOutlet var field2TextField:MDCOutlinedTextField!
    @IBOutlet var styleNumberTextField:MDCOutlinedTextField!
    @IBOutlet var searchButton:UIButton!
    
    var target: UIViewController?
    var type: HomeItemType? = .task
    let thePicker = UIPickerView()
    let toolBar = UIToolbar()
    var isFromTabBar: Bool = false
    
    weak var activeField: UITextField? {
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
  
    var tabBarVC: TabBarVC?
    
    var buyerData: [ContactsData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var factoryData: [ContactsData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    var pcuData: [ContactsData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
  
    var styleData: [DMSStyleData] = []{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    
    var editingStatus: String = "1"
    var orderId: String = "0"
    var orderNumber: String = "0"
    var styleNumber: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.taskDelegate = self
        self.setupUI()
        self.setupPickerViewWithToolBar()
        self.getTaskFilterList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadItems),
                                                   name: .reloadOrderFilterVC, object: nil)
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.taskDelegate = self
    
        self.appNavigationBarStyle()
        self.showNavigationBar()
        self.showCustomPresentedBackBarItem()
    }
  
    func setupUI(){
        self.view.backgroundColor = .white
        self.scrollView.backgroundColor = UIColor.init(rgb: 0xEFEFEF)
        self.contentView.backgroundColor = .white
        self.contentView.roundCorners(corners: .allCorners, radius: 10.0)
   
        
        [field1TextField, field2TextField, styleNumberTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .words
        }
    
        self.searchButton.backgroundColor = .primaryColor()
        self.searchButton.layer.cornerRadius = self.searchButton.frame.height / 2.0
       
        self.searchButton.setTitleColor(.white, for: .normal)
        self.searchButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.searchButton.addTarget(self, action: #selector(self.searchButtonTapped(_:)), for: .touchUpInside)
        
        self.updateSearchButton()
    }
    
    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        
        self.field1TextField.inputView = thePicker
        self.field2TextField.inputView = thePicker
        self.styleNumberTextField.inputView = thePicker
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .primaryColor()
        toolBar.sizeToFit()
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        toolBar.setItems([spaceButton1,doneButton], animated: false)
        
        self.field1TextField.inputAccessoryView = toolBar
        self.field2TextField.inputAccessoryView = toolBar
        self.styleNumberTextField.inputAccessoryView = toolBar
    }
    
    @objc func loadItems(){
        if isFromTabBar{
            self.addNavigationItem(type: [.menu], align: .left)
            var tempItems: [UIBarButtonItem] = []
            let menuButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(toggleHomeMenu(_:)))
            menuButton.tintColor = UIColor.white
            tempItems.append(menuButton)
            self.parent?.navigationItem.leftBarButtonItems = tempItems
           
            if self.type == .task{
                self.parent?.title = LocalizationManager.shared.localizedString(key: "taskUpdateText")
            }else if self.type == .dataInput{
                self.parent?.title = LocalizationManager.shared.localizedString(key:"prodDataInputTitle")
            }
            
            self.setupUI()
            self.setupPickerViewWithToolBar()
        }else{
            if self.type == .task{
                self.title = LocalizationManager.shared.localizedString(key: "taskUpdateText")
            }else if self.type == .dataInput{
                self.title = LocalizationManager.shared.localizedString(key:"prodDataInputTitle")
            }
        }
    
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            self.setup(field1TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "factoryText"))
            self.setup(field2TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "pcuText"))
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            self.setup(field1TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "buyerText"))
            self.setup(field2TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "pcuText"))
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            self.setup(field1TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "buyerText"))
            self.setup(field2TextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "factoryText"))
        }
        
        self.setup(styleNumberTextField, placeholderLabel: "\(LocalizationManager.shared.localizedString(key: "styleNoText"))*")
        if self.type == .task{
            self.searchButton.setTitle(LocalizationManager.shared.localizedString(key: "goToTaskUpdateText"), for: .normal)
        }else if self.type == .dataInput{
            self.searchButton.setTitle(LocalizationManager.shared.localizedString(key: "goToProductionUpdateText"), for: .normal)
        }
        
    }
 
    @objc func toggleHomeMenu(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .menuBar) as? MenuBarVC {
                vc.preferredSheetSizing = .large
                let navVC = UINavigationController(rootViewController:vc)
                navVC.isNavigationBarHidden = true
                navVC.modalPresentationStyle = .overCurrentContext
                navVC.modalTransitionStyle = .crossDissolve
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc override func doneButtonTapped(_ sender: AnyObject){
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            self.contentView.endEditing(true)
            thePicker.endEditing(true)
            return
        }
        
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            if activeField == field1TextField && row < factoryData.count{
                activeField?.text = factoryData[row].name
                activeField?.tag = Int(factoryData[row].id ?? "0") ?? 0
            }else if activeField == field2TextField && row < pcuData.count{
                activeField?.text = pcuData[row].name
                activeField?.tag = Int(pcuData[row].id ?? "0") ?? 0
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if activeField == field1TextField && row < buyerData.count{
                activeField?.text = buyerData[row].name
                activeField?.tag = Int(buyerData[row].id ?? "0") ?? 0
            }else if activeField == field2TextField && row < pcuData.count{
                activeField?.text = pcuData[row].name
                activeField?.tag = Int(pcuData[row].id ?? "0") ?? 0
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if activeField == field1TextField && row < buyerData.count{
                activeField?.text = buyerData[row].name
                activeField?.tag = Int(buyerData[row].id ?? "0") ?? 0
            }else if activeField == field2TextField && row < factoryData.count{
                activeField?.text = factoryData[row].name
                activeField?.tag = Int(factoryData[row].id ?? "0") ?? 0
            }
        }
        
         if activeField == styleNumberTextField && row < styleData.count{
            activeField?.text = "\(styleData[row].style_no ?? "") ( \(styleData[row].order_no ?? "") )"
             activeField?.tag = styleData[row].id ?? 0
             self.orderNumber = styleData[row].order_no ?? ""
             self.styleNumber = styleData[row].style_no ?? ""
        }
        
        self.contentView.endEditing(true)
        thePicker.endEditing(true)
    }
    
    func updateSearchButton(){
        if  self.styleNumberTextField.tag != 0{
            searchButton.backgroundColor = .primaryColor()
            searchButton.isUserInteractionEnabled = true
        }else{
            searchButton.backgroundColor = .gray
            searchButton.isUserInteractionEnabled = false
        }
    }
    @objc func searchButtonTapped(_ sender: UIButton){
        if self.type == .task{
            self.pushToTaskUpdateVC()
        }else if self.type == .dataInput{
            self.pushToDataInputVC()
        }
    }
   
    func pushToTaskUpdateVC(){
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewTaskUpdates.rawValue) == true{
            if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskUpdate) as? TaskUpdateVC {
                vc.orderId = "\(self.styleNumberTextField.tag)"
                vc.orderNo = self.orderNumber
                vc.styleNo = self.styleNumber
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
        }
    }
    
    func pushToDataInputVC(){
     
       if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewDataInput.rawValue) == true{
            if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .productionUpdate) as? ProductionUpdateVC {
                vc.orderId = "\(self.styleNumberTextField.tag)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
        }

    }
 
    func getTaskFilterList(){
        self.styleNumberTextField.text = ""
        
        self.showHud()
        let params:[String:Any] = [ "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getTaskFilterData(params: params)
    }
    
    func getStyleOrderList(){
        
        self.showHud()
        var params:[String:Any] = [ "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            if self.field1TextField.tag != 0{
                params["factory_id"] = self.field1TextField.tag
            }
            if self.field2TextField.tag != 0{
                params["pcu_id"] = self.field2TextField.tag
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if self.field1TextField.tag != 0{
                params["buyer_id"] = self.field1TextField.tag
            }
            if self.field2TextField.tag != 0{
                params["pcu_id"] = self.field2TextField.tag
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if self.field1TextField.tag != 0{
                params["buyer_id"] = self.field1TextField.tag
            }
            if self.field2TextField.tag != 0{
                params["factory_id"] = self.field2TextField.tag
            }
        }

        print(params)
        RestCloudService.shared.getStylesData(params: params)
    }

}

extension OrderFilterVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            if textField == field1TextField && factoryData.count > 0 && textField.text?.count == 0{
                textField.text = factoryData[0].name
                textField.tag = Int(factoryData[0].id ?? "0") ?? 0
            }else if textField == field2TextField && pcuData.count > 0 && textField.text?.count == 0{
                textField.text = pcuData[0].name
                textField.tag = Int(pcuData[0].id ?? "0") ?? 0
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if textField == field1TextField && buyerData.count > 0 && textField.text?.count == 0{
                textField.text = buyerData[0].name
                textField.tag = Int(buyerData[0].id ?? "0") ?? 0
            }else if textField == field2TextField && pcuData.count > 0 && textField.text?.count == 0{
                textField.text = pcuData[0].name
                textField.tag = Int(pcuData[0].id ?? "0") ?? 0
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if textField == field1TextField && buyerData.count > 0 && textField.text?.count == 0{
                textField.text = buyerData[0].name
                textField.tag = Int(buyerData[0].id ?? "0") ?? 0
            }else if textField == field2TextField && factoryData.count > 0 && textField.text?.count == 0{
                textField.text = factoryData[0].name
                textField.tag = Int(factoryData[0].id ?? "0") ?? 0
            }
        }
        
        if textField == styleNumberTextField && styleData.count > 0 && textField.text?.count == 0{
            textField.text = "\(styleData[0].style_no ?? "") ( \(styleData[0].order_no ?? "") )"
            textField.tag = styleData[0].id ?? 0
            self.editingStatus = styleData[0].status ?? "1"
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == field1TextField || textField == field2TextField{
            if field1TextField.tag != 0 || field2TextField.tag != 0{
                self.styleNumberTextField.tag = 0
                self.styleNumberTextField.text = ""
                self.getStyleOrderList()
            }
        }
        activeField = nil
        self.updateSearchButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension OrderFilterVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            if activeField == field1TextField{
                return factoryData.count
            }else if activeField == field2TextField{
                return pcuData.count
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if activeField == field1TextField{
                return buyerData.count
            }else if activeField == field2TextField{
                return pcuData.count
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if activeField == field1TextField{
                return buyerData.count
            }else if activeField == field2TextField{
                return factoryData.count
            }
        }
        
        if activeField == styleNumberTextField{
            return styleData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            if activeField == field1TextField && row < factoryData.count{
                return factoryData[row].name
            }else if activeField == field2TextField && row < pcuData.count{
                return pcuData[row].name
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if activeField == field1TextField && row < buyerData.count{
                return buyerData[row].name
            }else if activeField == field2TextField && row < pcuData.count{
                return pcuData[row].name
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if activeField == field1TextField && row < buyerData.count{
                return buyerData[row].name
            }else if activeField == field2TextField && row < factoryData.count{
                return factoryData[row].name
            }
        }
        
        if activeField == styleNumberTextField && row < styleData.count{
            return "\(styleData[row].style_no ?? "") ( \(styleData[row].order_no ?? "") )"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
}

extension OrderFilterVC: RCTaskDelegate{
    func didReceiveStylesFilter(data: DMSGetFilterTaskData?){
        self.hideHud()
        if let filterData = data{
            self.buyerData = filterData.buyer ?? []
            self.factoryData = filterData.factory ?? []
            self.pcuData = filterData.pcu ?? []
            
            if let styleData = data{
                self.styleData = styleData.style?.filter{$0.step_level == Config.stepLevel && $0.status == "1"} ?? []
            }
        }
    }
    
    func didFailedToReceiveStylesFilter(errorMessage: String){
        self.hideHud()
    }
    
    func didReceiveGetStyles(data: [DMSStyleData]?){
        self.hideHud()
        if let styleData = data{
            self.styleData = styleData
        }
    }
    
    func didFailedToReceiveGetStyles(errorMessage: String){
        self.hideHud()
    }
}
