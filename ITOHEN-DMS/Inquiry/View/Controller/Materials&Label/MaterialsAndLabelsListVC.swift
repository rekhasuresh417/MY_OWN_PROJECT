//
//  MaterialsAndLabelsListVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 21/04/23.
//

import UIKit
import MaterialComponents

protocol AddLabelContentDelegate{
    func getLabelContentList()
}

class MaterialsAndLabelsListVC: UIViewController {
    
    @IBOutlet var purchaseOrderTextField: MDCOutlinedTextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chooseOptionsLabel: UILabel!
    @IBOutlet var tabBarStackView: UIStackView!
    @IBOutlet var topView: UIView!
    
    @IBOutlet var allLabel: UILabel!
    @IBOutlet var printLabelLabel: UILabel!
    @IBOutlet var mainLabelLabel: UILabel!
    @IBOutlet var washCareLabel: UILabel!
    @IBOutlet var handTagLabel: UILabel!
    @IBOutlet var barCodeLabel: UILabel!
    @IBOutlet var polyBagLabel: UILabel!
    @IBOutlet var cartonLabel: UILabel!
    
    @IBOutlet var allButtonView: UIView!
    @IBOutlet var printArtworkButtonView: UIView!
    @IBOutlet var mainLabelButtonView: UIView!
    @IBOutlet var washCareButtonView: UIView!
    @IBOutlet var handTagButtonView: UIView!
    @IBOutlet var barCodeButtonView: UIView!
    @IBOutlet var polyBagButtonView: UIView!
    @IBOutlet var cartonButtonView: UIView!
    
    @IBOutlet var allButton: UIButton!
    @IBOutlet var printArtworkButton: UIButton!
    @IBOutlet var mainLabelButton: UIButton!
    @IBOutlet var washCareButton: UIButton!
    @IBOutlet var handTagButton: UIButton!
    @IBOutlet var barCodeButton: UIButton!
    @IBOutlet var polyBagButton: UIButton!
    @IBOutlet var cartonButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    
    @IBOutlet var printTabButton: UIButton!
    @IBOutlet var trimsTabButton: UIButton!
    @IBOutlet var packingTabButton: UIButton!
    @IBOutlet var tabStackViewHConstraint: NSLayoutConstraint!
    //@IBOutlet var collectionViewHeaderViewHConstraint: NSLayoutConstraint!
    @IBOutlet var topViewHConstraint: NSLayoutConstraint!
    @IBOutlet var nodataFoundView: UIView!
    @IBOutlet var noResultLabel: UILabel!
    
    var tabName: String = ""
    var userId: String = ""
    weak var activeField: UITextField?{
        didSet{
            self.thePicker.reloadAllComponents()
        }
    }
    let thePicker = UIPickerView()
    let theToolbarForPicker = UIToolbar()
    
    var tempPOChatDataModel: [POChatModel]? = []
    var poChatDataModel: [POChatModel]? = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    var chatDict: [Chat] = [ Chat(title: "Print ArtWork", type: "PrintArtWork"),
                             Chat(title: "Main Label", type: "MainLabel"),
                             Chat(title: "Wash Care", type: "WashCare"),
                             Chat(title: "Hang Tag", type: "HangTag"),
                             Chat(title: "Bar Code", type: "BarCode"),
                             Chat(title: "Poly Bag", type: "PolyBag"),
                             Chat(title: "Carton", type: "Carton") ]
    
    var labelInquiryIdsData: [LabelInquiryIdsData] = []
    var inquiryPOChatData: [InquiryPOChatData] = []
    var filterData: [String] = []
    var tempFilterData: [String] = ["PrintArtWork","MainLabel","WashCare","HangTag","BarCode","PolyBag","Carton"]
    
    var serverURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.materialsAndLabelDelegate = self
        self.setupUI()
        // assign userId
         if RMConfiguration.shared.loginType == Config.Text.staff{
             userId = RMConfiguration.shared.staffId
         }else{
             userId = RMConfiguration.shared.userId
         }
        
        self.setupPickerViewWithToolBar()
        self.getLabelInquiryIds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.materialsAndLabelDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key:"materialAndLabelText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        self.tabBarStackView.applyLightShadow()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
      //  self.tableView.tableHeaderView = self.topView
        self.tableView.isHidden = true
        self.tableView.roundCorners(corners: .allCorners, radius: 8)
        self.nodataFoundView.isHidden = true
        
        self.topView.isHidden = true
        [purchaseOrderTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .none
        }

        self.allLabel.text = LocalizationManager.shared.localizedString(key:"allButtonText")
        self.printLabelLabel.text = LocalizationManager.shared.localizedString(key:"printArtWorkText")
        self.mainLabelLabel.text = LocalizationManager.shared.localizedString(key:"mainLabelText")
        self.washCareLabel.text = LocalizationManager.shared.localizedString(key:"washCareText")
        self.handTagLabel.text = LocalizationManager.shared.localizedString(key:"hangTagText")
        self.barCodeLabel.text = LocalizationManager.shared.localizedString(key:"barCodeText")
        self.polyBagLabel.text = LocalizationManager.shared.localizedString(key:"polyBagText")
        self.cartonLabel.text = LocalizationManager.shared.localizedString(key:"cartonText")

        [allButton, printArtworkButton, mainLabelButton, washCareButton, handTagButton, barCodeButton, polyBagButton, cartonButton].forEach { (theButton) in
            theButton?.tintColor = .white
            theButton?.setTitle("", for: .normal)
            theButton?.isUserInteractionEnabled = false
            theButton?.isEnabled = true
            theButton?.tintColor = .inquiryPrimaryColor()
        }
        self.allButtonTapped()
        self.tabName = "print"
        
        [searchButton].forEach { (theButton) in
            theButton?.backgroundColor = .inquiryPrimaryColor()
            theButton?.setTitleColor(.white, for: .normal)
            theButton?.layer.borderWidth  = 1.0
            theButton?.layer.borderColor = UIColor.primaryColor().cgColor
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        }
        
        allButtonView.tag = 1
        printArtworkButtonView.tag = 2
        mainLabelButtonView.tag = 3
        washCareButtonView.tag = 4
        handTagButtonView.tag = 5
        barCodeButtonView.tag = 6
        polyBagButtonView.tag = 7
        cartonButtonView.tag = 8
        [allButtonView, printArtworkButtonView, mainLabelButtonView, washCareButtonView, handTagButtonView, barCodeButtonView, polyBagButtonView, cartonButtonView].forEach { (theView) in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapView(sender:)))
            theView.addGestureRecognizer(tapGesture)
        }
        
        self.searchButton.layer.cornerRadius =  self.searchButton.frame.height/2
        self.searchButton.setTitle("     \(LocalizationManager.shared.localizedString(key: "searchText"))     ", for: .normal)
        self.setup(purchaseOrderTextField!, placeholderLabel: LocalizationManager.shared.localizedString(key: "purchaseOrderText"), color: .inquiryPrimaryColor())
        
        printTabButton.tag = 1
        trimsTabButton.tag = 2
        packingTabButton.tag = 3
        
        self.printTabButton.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.5)
        self.trimsTabButton.backgroundColor = .systemGray5
        self.packingTabButton.backgroundColor = .systemGray5
        self.printTabButton.setTitleColor(.customBlackColor(), for: .normal)
        self.trimsTabButton.setTitleColor(.lightGray, for: .normal)
        self.packingTabButton.setTitleColor(.lightGray, for: .normal)
        
        // In default selected all
        self.filterData = self.tempFilterData
        
        // hode tabbar
        self.hideTabbar()
        
        self.printTabButton.setTitle(LocalizationManager.shared.localizedString(key:"printInfoText"), for: .normal)
        self.trimsTabButton.setTitle(LocalizationManager.shared.localizedString(key:"trimInfoText"), for: .normal)
        self.packingTabButton.setTitle(LocalizationManager.shared.localizedString(key:"packingInfoText"), for: .normal)
        self.searchButton.addTarget(self, action: #selector(self.searchButtonTapped(_:)), for: .touchUpInside)
        self.printTabButton.addTarget(self, action: #selector(self.tabbarButtonTapped(_:)), for: .touchUpInside)
        self.trimsTabButton.addTarget(self, action: #selector(self.tabbarButtonTapped(_:)), for: .touchUpInside)
        self.packingTabButton.addTarget(self, action: #selector(self.tabbarButtonTapped(_:)), for: .touchUpInside)
    }
    
    func getLabelInquiryIds() {
        self.showHud()
     
        let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "user_id": userId,
                                      "user_type": RMConfiguration.shared.workspaceType,
                                      "login_type": RMConfiguration.shared.loginType ]
        print(params)
        RestCloudService.shared.getLabelInquiryIds(params: params)
    }
    
    func getInquiryPOChat() {
        self.showHud()
        RestCloudService.shared.materialsAndLabelDelegate = self
        let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "user_id": userId,
                                      "inquiry_id": self.purchaseOrderTextField.tag ]
        print(params)
        RestCloudService.shared.getInquiryPOChat(params: params)
    }
    
    func setupPickerViewWithToolBar(){
        thePicker.dataSource = self
        thePicker.delegate = self
        theToolbarForPicker.sizeToFit()
     
        self.purchaseOrderTextField.inputView = thePicker
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"),
                                         style:.plain, target: self,
                                         action: #selector(doneButtonTapped(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let clearButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "clearText"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(clearButtonTapped(_:)))
        self.theToolbarForPicker.setItems([clearButton, spaceButton, doneButton], animated: false)
        
        self.purchaseOrderTextField.inputAccessoryView = theToolbarForPicker
    }
    
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        self.view.endEditing(true)
    }
    
    @objc override func doneButtonTapped(_ sender:AnyObject) {
        let row =  self.thePicker.selectedRow(inComponent: 0)
        
        if row < 0 { //returns -1 if nothing selected
            thePicker.endEditing(true)
            return
        }
        
        if activeField == purchaseOrderTextField && row < labelInquiryIdsData.count{
            activeField?.text = "PO-\(labelInquiryIdsData[row].id ?? 0)"
            activeField?.tag = labelInquiryIdsData[row].inquiry_id ?? 0
            poChatDataModel = [] //
        }
        self.tabName = "print"
        self.tableView.isHidden = false
        self.topView.isHidden = false
        self.view.endEditing(true)
        thePicker.endEditing(true)
    }
    
    @objc func tabbarButtonTapped(_ sender: UIButton){
        if sender.tag == 1{
            self.tabName = "print"
            self.printArtWorkInfoTap()
        }else  if sender.tag == 2{
            self.tabName = "trim"
            self.trimsInfoTap()
        }else if sender.tag == 3{
            self.tabName = "pack"
            self.packingInfoTap()
        }
    }
   
    func printArtWorkInfoTap(){
        self.printTabButton.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.5)
        self.trimsTabButton.backgroundColor = .systemGray5
        self.packingTabButton.backgroundColor = .systemGray5
        self.printTabButton.setTitleColor(.customBlackColor(), for: .normal)
        self.trimsTabButton.setTitleColor(.lightGray, for: .normal)
        self.packingTabButton.setTitleColor(.lightGray, for: .normal)
    
        var tempFilter: [String] = []
        if filterData.contains(MaterialsAndLabelType.printArtWork.rawValue){
            tempFilter.append(MaterialsAndLabelType.printArtWork.rawValue)
        }
        self.getFilterData(types: tempFilter)
    }
    func trimsInfoTap(){
        self.printTabButton.backgroundColor = .systemGray5
        self.trimsTabButton.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.5)
        self.packingTabButton.backgroundColor = .systemGray5
        self.printTabButton.setTitleColor(.lightGray, for: .normal)
        self.trimsTabButton.setTitleColor(.customBlackColor(), for: .normal)
        self.packingTabButton.setTitleColor(.lightGray, for: .normal)
       
        var tempFilter: [String] = []
        if filterData.contains(MaterialsAndLabelType.mainLabel.rawValue){
            tempFilter.append(MaterialsAndLabelType.mainLabel.rawValue)
        }
        if filterData.contains(MaterialsAndLabelType.washCare.rawValue){
            tempFilter.append(MaterialsAndLabelType.washCare.rawValue)
        }
        if filterData.contains(MaterialsAndLabelType.hangTag.rawValue){
            tempFilter.append(MaterialsAndLabelType.hangTag.rawValue)
        }
        if filterData.contains(MaterialsAndLabelType.barCode.rawValue){
            tempFilter.append(MaterialsAndLabelType.barCode.rawValue)
        }
        self.getFilterData(types: tempFilter)
    }
    func packingInfoTap(){
        self.printTabButton.backgroundColor = .systemGray5
        self.trimsTabButton.backgroundColor = .systemGray5
        self.printTabButton.setTitleColor(.lightGray, for: .normal)
        self.trimsTabButton.setTitleColor(.lightGray, for: .normal)
        self.packingTabButton.setTitleColor(.customBlackColor(), for: .normal)
        self.packingTabButton.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.5)
     
        var tempFilter: [String] = []
        if filterData.contains(MaterialsAndLabelType.polyBag.rawValue){
            tempFilter.append(MaterialsAndLabelType.polyBag.rawValue)
        }
        if filterData.contains(MaterialsAndLabelType.carton.rawValue){
            tempFilter.append(MaterialsAndLabelType.carton.rawValue)
        }
        self.getFilterData(types: tempFilter)
    }
    
    func getFilterData(types: [String]){
        self.poChatDataModel = []
        var count: Int = 0
        for type in types{
            
            if let data = self.tempPOChatDataModel?.filter({$0.type == type}), data.count > 0 {
                self.poChatDataModel?.insert(contentsOf: data, at: count)
                count = count + 1
            }
        }
    
        let model = self.poChatDataModel?.filter({$0.data?.count ?? 0 > 0 })
        self.nodataFoundView.isHidden = model?.count ?? 0 > 0 ? true :  false
    }
    
    @objc func searchButtonTapped(_ sender: UIButton){
        print(self.filterData)
        self.getInquiryPOChat()
        self.updateTabbar()
    }
    
    func updateTabbar(){
        if purchaseOrderTextField.text?.isEmptyOrWhitespace() == false{
            showTabbar()
        }else{
            hideTabbar()
        }
    }
    
    func hideTabbar(){
        self.tabBarStackView.isHidden = true
        self.tabStackViewHConstraint.constant = 0.0
        self.topViewHConstraint.constant = 150.0
    }
    func showTabbar(){
        self.tabBarStackView.isHidden = false
         self.tabStackViewHConstraint.constant = 38.0
          self.topViewHConstraint.constant = 180.0
    }
    
    func getModelData(){
        self.tempPOChatDataModel = []
        for dict in chatDict{
            self.tempPOChatDataModel?.append(POChatModel.init(title: dict.title,
                                                              type: dict.type,
                                                              data: self.bindData(type: dict.type)))
        }
        
        print(tempPOChatDataModel)
        if self.tabName == "print"{
            self.printArtWorkInfoTap()
        }else if self.tabName == "trim"{
            self.trimsInfoTap()
        }else{
            self.packingInfoTap()
        }
        
    }
    
    func bindData(type: String) -> [InquiryPOModel]{
        
        var tempModel: [InquiryPOModel] = []
        var inquiryChatData: [InquiryPOChatData] = []
        var refArray: [String] = []
                
        // 1. Different user
        // 2. Get type model
        for data in inquiryPOChatData{
            if data.type == type{
                if data.userId == Int(userId){ // Same user
                    inquiryChatData.append(data)
                }else{
                    if data.publishStatus == 1{ // If  Different user, PO should be published
                        inquiryChatData.append(data)
                    }
                }
            }
        }

        // Get all reference Id
        for item in inquiryChatData{
            if !refArray.contains(item.referenceId ?? ""){
                refArray.append(item.referenceId ?? "")
            }
        }
        
        // Get images and texts
        for refId in refArray{
            var printImageArray: [String] = []
            var printTextArray: [String] = []
            let getModel = self.inquiryPOChatData.filter({$0.referenceId == refId})
            
            for model in getModel{
                if model.contentType == "image"{
                    printImageArray.append(self.serverURL+(model.content ?? ""))
                }else{
                    printTextArray.append(model.content ?? "")
                }
            }
            
            var tempPOChatData: [InquiryPOChatData] = []
            tempPOChatData = self.inquiryPOChatData.filter({$0.referenceId == refId && $0.publishStatus == 1})
            if tempPOChatData.count == 0 {
                tempPOChatData = self.inquiryPOChatData.filter({$0.referenceId == refId})
            }
            
            var userName: String = ""
            if RMConfiguration.shared.loginType == Config.Text.staff && tempPOChatData[0].userType?.lowercased() == Config.Text.staff.lowercased(){
                userName = tempPOChatData[0].staffName ?? ""
            }else{
                userName = tempPOChatData[0].userName ?? ""
            }
            
            tempModel.append(InquiryPOModel.init(id: tempPOChatData[0].id ?? 0,
                                                 poId: tempPOChatData[0].poId ?? 0,
                                                 image: printImageArray,
                                                 text: printTextArray,
                                                 printDate: tempPOChatData[0].createdDate ?? "",
                                                 type: tempPOChatData[0].type ?? "",
                                                 status: tempPOChatData[0].publishStatus ?? 0,
                                                 printUser: userName,
                                                 ref: tempPOChatData[0].referenceId ?? ""))
        }
        return tempModel
    }
    
    @objc func didTapView(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 1:
            print("view1 clicked")
            self.allButtonTapped()
        case 2:
            print("view2 clicked")
            self.printArtworkButtonTapped()
        case 3:
            print("view3 clicked")
            self.mainLabelButtonTapped()
        case 4:
            print("view4 clicked")
            self.washCareButtonTapped()
        case 5:
            print("view5 clicked")
            self.handTagButtonTapped()
        case 6:
            print("view6 clicked")
            self.barCodeButtonTapped()
        case 7:
            print("view7 clicked")
            self.polyBagButtonTapped()
        case 8:
            print("view8 clicked")
            self.cartonButtonTapped()
        default:
            return
        }
    }
    
    func checkAllSelected(){
        if printArtworkButton.isSelected && mainLabelButton.isSelected && washCareButton.isSelected && handTagButton.isSelected && barCodeButton.isSelected && polyBagButton.isSelected && cartonButton.isSelected {
            [allButton].forEach { (theButton) in
                theButton?.isSelected = true
                theButton?.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
            }
        }
    }
    
    func allButtonTapped(){
        if allButton.isSelected {
            self.filterData = []
            [allButton, printArtworkButton, mainLabelButton, washCareButton, handTagButton, barCodeButton, polyBagButton, cartonButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            self.filterData = self.tempFilterData
            [allButton, printArtworkButton, mainLabelButton, washCareButton, handTagButton, barCodeButton, polyBagButton, cartonButton].forEach { (theButton) in
                theButton?.isSelected = true
                theButton?.tintColor = .white
                theButton?.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
            }
        }
    }
    
    func printArtworkButtonTapped(){
        if printArtworkButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.printArtWork.rawValue}
            
            [allButton, printArtworkButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.printArtWork.rawValue)
            
            printArtworkButton.isSelected = true
            printArtworkButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    func mainLabelButtonTapped(){
        if mainLabelButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.mainLabel.rawValue}
            
            [allButton, mainLabelButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.mainLabel.rawValue)
            
            mainLabelButton.isSelected = true
            mainLabelButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    func washCareButtonTapped(){
        if washCareButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.washCare.rawValue}
            
            [allButton, washCareButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.washCare.rawValue)
            
            washCareButton.isSelected = true
            washCareButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    func handTagButtonTapped(){
        if handTagButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.hangTag.rawValue}
            
            [allButton, handTagButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.hangTag.rawValue)
            
            handTagButton.isSelected = true
            handTagButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    func barCodeButtonTapped(){
        if barCodeButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.barCode.rawValue}
            
            [allButton, barCodeButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.barCode.rawValue)
            
            barCodeButton.isSelected = true
            barCodeButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    func polyBagButtonTapped(){
        if polyBagButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.polyBag.rawValue}
            
            [allButton, polyBagButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.polyBag.rawValue)
            
            polyBagButton.isSelected = true
            polyBagButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    func cartonButtonTapped(){
        if cartonButton.isSelected {
            filterData.removeAll{ $0 == MaterialsAndLabelType.carton.rawValue}
            
            [allButton, cartonButton].forEach { (theButton) in
                theButton?.isSelected = false
                theButton?.setImage(UIImage.init(named: Config.Images.checkboxIcon), for: .normal)
            }
        }else{
            filterData.append(MaterialsAndLabelType.carton.rawValue)
            cartonButton.isSelected = true
            cartonButton.setImage(UIImage.init(named: Config.Images.inq_checkboxTickIcon), for: .normal)
        }
        self.checkAllSelected()
    }
    
    // Multi images show
    @objc func multiImageViewTapped(sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            if let bottomView = sender.view?.superview{
                if let mainView = bottomView.superview{
                    if let hasCell = mainView.superview?.superview as? MaterialsAndLabelListTableViewCell{
                        
                        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryPOMultiImage) as? InquiryPOMultiImageVC {
                            vc.images = hasCell.data?.image
                            vc.screenTitle = hasCell.data?.type ?? ""
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    @objc func addButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let bottomView = sender.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview?.superview?.superview as? MaterialsAndLabelListTableViewCell{
                      
                        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryChatContent) as? InquiryChatContentVC {
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            vc.userId = self.userId
                            vc.data = hasCell.data
                            vc.isFrom = Config.UpdateStatus.ADD
                            vc.delegate = self
                            self.present(vc, animated: true, completion: nil)
                        }
               
                    }
                }
            }
        }
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let bottomView = sender.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview?.superview?.superview as? MaterialsAndLabelListTableViewCell {
                      
                        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryChatContent) as? InquiryChatContentVC {
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = .crossDissolve
                            vc.userId = self.userId
                            vc.data = hasCell.data
                            vc.isFrom = Config.UpdateStatus.EDIT
                            vc.delegate = self
                            self.present(vc, animated: false, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
}

extension MaterialsAndLabelsListVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeField == purchaseOrderTextField{
            return self.labelInquiryIdsData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeField == purchaseOrderTextField{
            return "PO-\(labelInquiryIdsData[row].id ?? 0)"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension MaterialsAndLabelsListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return poChatDataModel?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poChatDataModel?[section].data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MaterialsAndLabelListTableViewCell
        if let data = self.poChatDataModel?[indexPath.section].data?[indexPath.row]{
            cell.setContent(index:indexPath.row,
                            rowCount: self.poChatDataModel?[indexPath.section].data?.count ?? 0,
                            data: data,
                            target: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.pushToOrderInfo(id: self.onGoingList[indexPath.row].id ?? "")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}

extension MaterialsAndLabelsListVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MaterialsAndLabelsListVC: RCMaterialsAndLabelDelegate{
    
    /// Get Label Inquiry Ids
    func didReceiveGetLabelInquiryIds(data: [LabelInquiryIdsData]?){
        self.hideHud()
        if let idsData = data{
            self.labelInquiryIdsData = idsData
        }
    }
    
    func didFailedToReceiveGetLabelInquiryIds(errorMessage: String){
        self.hideHud()
    }
 
    /// Get Label Inquiry Ids
    func didReceiveGetInquiryPOChat(data: InquiryPOChatResponse?){
        self.hideHud()
        if let response = data{
            self.inquiryPOChatData = response.data ?? []
            self.serverURL = response.serverURL ?? ""
            self.getModelData()
        }
    }
    
    func didFailedToReceiveGetInquiryPOChat(errorMessage: String){
        self.hideHud()
    }
    
}

extension MaterialsAndLabelsListVC : AddLabelContentDelegate{
    func getLabelContentList() {
        RestCloudService.shared.materialsAndLabelDelegate = self
        self.getInquiryPOChat()
    }
}

struct Chat {
    let title: String
    let type: String
}
