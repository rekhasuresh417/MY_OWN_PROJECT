//
//  OrderInfoVC.swift
//  Itohen-dms
//
//  Created by Dharma on 11/01/21.
//

import UIKit
import MaterialComponents

protocol OrderInfoDataUpdateDelegate {
    func updateOrderInfoData(_ type:OrderInfoDataType, orderInfoData: DMSOrderInfo?)
}

enum OrderInfoDataType {
    case basic
    case contact
    case task
    case production
}

class OrderInfoVC: UIViewController {
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var bottomView:UIView!
    @IBOutlet var bottomViewHConstraint:NSLayoutConstraint!
    @IBOutlet var taskUpdateButton:UIButton!
    @IBOutlet var productionUpdateButton:UIButton!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var deleteImmediatelyButton: UIButton!
   
    let kHeaderSectionTag: Int = 6900;
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
 
    weak var activeView: UIView?
    var orderStatusType : String = ""
    var basicInfoData: Basic?
    var isEditProduction: Bool = false
    
    var taskTableView: UITableView!
    
    var basicInfoModel: BasicInfoModel = BasicInfoModel.init(isSkuDataAvailable: false, skuType: .size, data: nil, skuData: [], skuSizeData: [], skuColorData: [], section: 0) {
        didSet{
            if self.basicInfoModel.isSkuDataAvailable{
                self.contactModel.isSectionEnabled = true
            }else{
                self.contactModel.isSectionEnabled = false
            }
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    var contactModel: ContactModel = ContactModel.init(isSectionEnabled: true, isDataAvailable: false, section: 1, data: [])
    {
        didSet{
            self.contactModel.isDataAvailable = contactModel.data.count > 0
            self.taskModel.isSectionEnabled = contactModel.data.count > 0 && self.basicInfoModel.isSkuDataAvailable ? true : false
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    var taskModel: TaskModel = TaskModel.init(isSectionEnabled: false, isDataAvailable: false, section: 2, templateId: "", data: [])
    {
        didSet{
            self.taskModel.isDataAvailable = self.taskModel.data.count > 0 ? true : false
            self.productionModel.isSectionEnabled = self.taskModel.data.count > 0 ? true : false
            self.updateBottomViewUI()
            self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }
    }
    
    var productionModel: ProductionModel = ProductionModel.init(isSectionEnabled: false, isDataAvailable: false, section: 3, cutData: [], sewData: [], packData: [])
    {
        didSet{
            self.productionModel.isDataAvailable = self.productionModel.cutData?.count ?? 0 > 0 ? true : false
            self.updateBottomViewUI()
            self.tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
        }
    }
    
    var involvedColor: [String] = []
    var involvedSize: [String] = []
    
    var taskDataModel: [EditTaskTemplateData] = []
    var dataSource:[OrderInfoDataSource] = []
    var orderId:String = "0"
    var contactsCVTag:Int = 101
    var editTag:Int = 901
    var viewTag:Int = 902
    var addTag:Int = 903
    
    let basicInfoCellHeight:CGFloat = 230.0
    let basicInfoWithSkuCellHeight:CGFloat = 390.0
    let addContactCellHeight:CGFloat = 160.0
    let noOfTaskProgress:CGFloat = 3.0 // no of rows
    let addTaskCellHeight:CGFloat = 160.0
    let taskProgressCellHeight:CGFloat = 96.0 // top & bottom view spaces
    let taskProgressContentCellHeight:CGFloat = 60.0
    let addProductionCellHeight:CGFloat = 160.0
    let productionContentCellHeight:CGFloat = 210.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.orderInfoDelegate = self
        
        self.loadDataSource()
        self.setupUI()
        self.getOrderInfo()
      
       self.setNeedsStatusBarAppearanceUpdate()
        RMConfiguration.shared.orderId = self.orderId
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        RestCloudService.shared.orderInfoDelegate = self
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "orderInfoTitle")
    }
    
    func loadDataSource(){
        self.dataSource.append(self.basicInfoModel)
        self.dataSource.append(self.contactModel)
        self.dataSource.append(self.taskModel)
        self.dataSource.append(self.productionModel)
    }
    
    func setupUI(){
        self.view.backgroundColor = .appBackgroundColor()
        self.contentView.backgroundColor = .clear
        
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.bottomView.backgroundColor = .white
    
        self.taskUpdateButton.backgroundColor = .white
        self.taskUpdateButton.layer.borderWidth = 1.0
        self.taskUpdateButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.taskUpdateButton.layer.cornerRadius = self.taskUpdateButton.frame.height / 2.0
        self.taskUpdateButton.setTitle(LocalizationManager.shared.localizedString(key: "taskUpdateText"), for: .normal)
        self.taskUpdateButton.setTitleColor(.primaryColor(), for: .normal)
        self.taskUpdateButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .medium)
        self.taskUpdateButton.addTarget(self, action: #selector(self.taskUpdateButtonTapped(_:)), for: .touchUpInside)
        
        self.productionUpdateButton.backgroundColor = .primaryColor()
        self.productionUpdateButton.layer.cornerRadius = self.productionUpdateButton.frame.height / 2.0
        self.productionUpdateButton.setTitle(LocalizationManager.shared.localizedString(key: "productionUpdateButtonText"), for: .normal)
        self.productionUpdateButton.setTitleColor(.white, for: .normal)
        self.productionUpdateButton.titleLabel?.font = UIFont.appFont(ofSize: 12.0, weight: .regular)
        self.productionUpdateButton.addTarget(self, action: #selector(self.productionUpdateButtonTapped(_:)), for: .touchUpInside)
    
        deleteImmediatelyButton.addTarget(self, action: #selector(self.deleteImmediatelyButtonTapped(_:)), for: .touchUpInside)
      
        deleteImmediatelyButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        deleteImmediatelyButton.layer.cornerRadius = self.deleteImmediatelyButton.frame.height / 2.0
        deleteImmediatelyButton.backgroundColor = .delayedColor(withAlpha: 0.3)
        deleteImmediatelyButton.setTitleColor(.delayedColor(), for: .normal)
      
        if orderStatusType == "delete"{
            deleteImmediatelyButton.setTitle(LocalizationManager.shared.localizedString(key: "deleteImmediatelyText"), for: .normal)
        }else if orderStatusType == "complete"{
            deleteImmediatelyButton.setTitle(LocalizationManager.shared.localizedString(key: "closeImmediatelyText"), for: .normal)
            deleteImmediatelyButton.backgroundColor = .primaryColor()
            deleteImmediatelyButton.setTitleColor(.white, for: .normal)
        }else{
            deleteImmediatelyButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelImmediatelyText"), for: .normal)
        }
        self.hideBottomView()
    }

    func checkCloseOrder(){
     
       if self.basicInfoModel.data?.minProdRange == "1" && self.basicInfoModel.data?.pendingTasks == "0" && self.basicInfoModel.data?.closeOrderStatus == "0"{
           popupPopView(orderStatusType: "complete")
        }
    }
    
    func checkCancelOrder(){
     
//        if self.productionModel.data?.cutPcs != "0" || self.productionModel.data?.sewPcs != "0" || self.productionModel.data?.packPcs != "0"{
//           popupPopView(orderStatusType: "cancel")
//        }else{
//            popupPopView(orderStatusType: "delete")
//        }
    }
    
    func popupPopView(orderStatusType: String){
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .popUpView) as? PopUpView{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.orderStatusType = orderStatusType
            vc.orderId = self.orderId
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func updateBottomViewUI(){
        
        self.bottomViewHConstraint.constant = 50.0
        self.bottomView.isHidden = false
        
        if orderStatusType != ""{
            self.productionUpdateButton.isHidden = true
            self.taskUpdateButton.isHidden = true
        }else{
            self.deleteImmediatelyButton.isHidden = true
            print(self.taskModel.isDataAvailable, self.productionModel.isDataAvailable)
            if self.taskModel.isDataAvailable && !self.productionModel.isDataAvailable{
                self.productionUpdateButton.isHidden = true
                self.taskUpdateButton.isHidden = false
            }else if self.productionModel.isDataAvailable && !self.taskModel.isDataAvailable{
                self.productionUpdateButton.isHidden = false
                self.taskUpdateButton.isHidden = true
                // Can't input production before task input
            }else if self.productionModel.isDataAvailable && self.taskModel.isDataAvailable{
                self.productionUpdateButton.isHidden = false
                self.taskUpdateButton.isHidden = false
               // self.taskUpdateButtonWConstraint = self.taskUpdateButtonWConstraint.setMultiplier(multiplier: 0.5)
            }else{
                self.hideBottomView()
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func hideBottomView(){
        self.bottomViewHConstraint.constant = 0.0
        self.bottomView.isHidden = true
    }
   
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    func getOrderInfo() {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print("getOrderInfo", params)
        RestCloudService.shared.getOrderInfo(params: params)
  
    }
   
    func bindValues(data: DMSOrderInfoData) {
        var model = self.basicInfoModel
        model.data = data.basic?[0]
        model.skuData = data.skuData ?? []
        model.isSkuDataAvailable = data.skuData?.count ?? 0>0 ? true : false
    
        print(model.isSkuDataAvailable)
        
        self.basicInfoModel = model
        self.prepreSkuData()
        self.checkCloseOrder()

        self.contactModel.data = data.contact ?? []
        
        if let model = data.task, model.count > 0{
            self.taskModel.templateId = model[0].id ?? ""
            self.taskModel.data = model//.data ?? []
            self.makeTaskData()
        }
        if let prodModel = data.production, prodModel.cuttingDetails?.count ?? 0 > 0{
            self.productionModel.cutData = prodModel.cuttingDetails
            self.productionModel.sewData = prodModel.sewingDetails
            self.productionModel.packData = prodModel.packingDetails
        }
        if let prodPercentage = data.prodPercentage{
            self.productionModel.percentage = prodPercentage
        }
    }
    
    func makeTaskData(){
        var taskTitle: [String] = []
        self.taskDataModel = []

        for taskData in self.taskModel.data{
            if !taskTitle.contains(taskData.categoryTitle ?? ""){
                taskTitle.append(taskData.categoryTitle ?? "")
            }
        }
        print(taskTitle)
        
        for (index, title) in taskTitle.enumerated(){
            print(index, title)
            var taskSubTitle: [EditTaskSubTitleData] = []

            for data in self.taskModel.data{

                if data.categoryTitle == title{
                    taskSubTitle.append(EditTaskSubTitleData.init(taskID: data.id ?? "", taskSeq: "", catTitle: "", taskTitle: data.taskTitle ?? "", taskPic: "", subTaskPic: "", taskStartDate: data.taskStartDate ?? "", subTaskStartDate: "", taskEndDate: data.taskEndDate ?? "", subTaskEndDate: "", taskAccomplishedDate: data.taskAccomplishedDate ?? "",subTaskAccomplishedDate: "", rescheduled: "", taskContacts: [], subTasks: [], isSubTask: false))
                }
            }
            
            self.taskDataModel.append(EditTaskTemplateData.init(taskTitle: title, taskSubTitles: taskSubTitle))
        }
        print(self.taskDataModel)
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
    
    func deleteOrder() {
        
        self.showHud()
        let params:[String:Any] = [ "order_id": RMConfiguration.shared.orderId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                   "company_id": RMConfiguration.shared.companyId,
                                   "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
       // RestCloudService.shared.getBasicInfo(params: params)
        
     /*   let path:String = Config.API.apiAcceptOrderStatusUpdateRequest
        let postData: [String:Any] = ["order_id": "\(self.orderId)",
                                      "action": orderStatusType]
        
        let resource = Resource<DMSOrderDelete,
                                DMSError>(jsonDecoder: JSONDecoder(),
                                          path: path,
                                          method: .post,
                                          params: postData,
                                          headers: [:])
        Self.sharedWebClient.load(resource: resource) { [weak self] response in
            guard let controller = self else { return }
            DispatchQueue.main.async { [self] in
                controller.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                print(response.value as Any)
                if response.value?.code == 200{
                    self?.showAlert(message: response.value?.message ?? "")
                    self?.navigateToHome()
                }else if let error = response.error {
                    controller.handleError(error)
                }else{
                    self?.showAlert(message: LocalizationManager.shared.localizedString(key1: "Common", key2: "unknownErrorText"))
                }
            }
        }*/
    }
    
    func prepreSkuData() {
        
        var sizeDict : [SizeAndColorDetails] = []
        var colorDict : [SizeAndColorDetails] = []
        
        for data in self.basicInfoModel.skuData{
            
            // Size dict
            let sIndex = sizeDict.indices.first { (index) in
                return sizeDict[index].id == data.sizeID
            }
            
            if let i = sIndex{
                if let intVal = Int(data.skuQuantity ?? ""){
                    sizeDict[i].quantity = sizeDict[i].quantity + intVal
                }
            }else{
                if let intVal = Int(data.skuQuantity ?? ""){
                    sizeDict.append(SizeAndColorDetails(id: data.sizeID ?? "", title: data.sizeTitle ?? "", quantity: intVal))
                }else{
                    sizeDict.append(SizeAndColorDetails(id: data.sizeID ?? "", title: data.sizeTitle ?? "", quantity: 0))
                }
            }
            
            // Color dict
            let cIndex = colorDict.indices.first { (index) in
                return colorDict[index].id == data.colorID
            }
            
            if let i = cIndex{
                if let intVal = Int(data.skuQuantity ?? ""){
                    colorDict[i].quantity = colorDict[i].quantity + intVal
                }
            }else{
                if let intVal = Int(data.skuQuantity ?? ""){
                    colorDict.append(SizeAndColorDetails(id: data.colorID ?? "", title: data.colorTitle ?? "", quantity: intVal))
                }else{
                    colorDict.append(SizeAndColorDetails(id: data.colorID ?? "", title: data.colorTitle ?? "", quantity: 0))
                }
            }
        }
  
        self.basicInfoModel.skuSizeData = sizeDict
        self.basicInfoModel.skuColorData = colorDict
        self.selectedSKUs()
    }
  
    func selectedSKUs(){
        for sizeData in self.basicInfoModel.skuSizeData {
            self.involvedSize.append(sizeData.id)
        }
        
        for colorData in self.basicInfoModel.skuColorData{
            self.involvedColor.append(colorData.id)
        }
    }
    
    @objc func taskUpdateButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskUpdate) as? TaskUpdateVC {
            vc.orderId = self.orderId
            vc.basicInfo = self.basicInfoModel.data
            vc.orderInfoDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func productionUpdateButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .productionUpdate) as? ProductionUpdateVC {
            vc.orderId = self.orderId
            vc.orderInfoDelegate = self
            vc.orderInfoSKUData = self.basicInfoModel.skuData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func deleteImmediatelyButtonTapped (_ sender: UIButton) {
        self.deleteOrder()
    }
    
    @objc func switchButtonTapped(_ sender: UISwitch) {
        self.basicInfoModel.skuType = self.basicInfoModel.skuType == .color ? .size : .color
    }
    
    @objc func editBasicInfoButtonTapped(_ sender: UIButton) {
        
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.editOrder.rawValue) == true{
            DispatchQueue.main.async {
                if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .newOrder) as? NewOrderVC {
                    vc.orderId = self.orderId
                    vc.orderInfoType = .editOrder
                    vc.basicInfoData = self.basicInfoData
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }else{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText") , message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"), target: self)
        }

    }

    @objc func viewOrAddSkuButtonTapped(_ sender: UIButton) {
        if self.basicInfoModel.isSkuDataAvailable{
            if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .viewSKU) as? SKUViewVC {
                vc.orderId = self.orderId
                vc.involvedColor = self.involvedColor
                vc.involvedSize = self.involvedSize
                vc.skuData = self.basicInfoModel.skuData
                vc.basicInfoData = self.basicInfoModel.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
  
        }else{
            if self.appDelegate().userDetails.userRole == .admin ||  self.appDelegate().userDetails.userRole == .manager || self.appDelegate().userDetails.userRole == .staff {
                if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addSKU) as? SKUAddVC {
                    vc.orderId = self.orderId
                    vc.finalSkuData = self.basicInfoModel.skuData
                    vc.skuData = self.basicInfoModel.skuData
                    vc.involvedColor = self.involvedColor
                    vc.involvedSize = self.involvedSize
                    vc.basicInfoData = self.basicInfoModel.data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText") , message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"), target: self)
            }
        }
    }
    
    @objc func addOrViewContactButtonTapped(_ sender: UIButton) {
        if  self.appDelegate().userDetails.userRole == .admin ||  self.appDelegate().userDetails.userRole == .manager || self.appDelegate().userDetails.userRole == .staff {
            // Full access
        }else{
            if sender.tag == self.editTag{
                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                            message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                            target: self)
                return
            }
            // Able to view contact list
        }
        
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .contactList) as? ContactListVC {
                vc.displayType = sender.tag == self.editTag ? .edit : .view
                vc.orderId = self.orderId
                vc.orderInfoDelegate = self
                vc.selectedContactsForOrder = self.contactModel.data.compactMap({$0.staffId})
                vc.basicInfoModel = self.basicInfoModel
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    @objc func addOrViewTaskButtonTapped(_ sender: UIButton) {
        if self.appDelegate().userDetails.userRole == .admin || self.appDelegate().userDetails.userRole == .manager || self.appDelegate().userDetails.userRole == .staff {
            // Full access
        }else{
            if sender.tag == self.addTag{
                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                            message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                            target: self)
                return
            }
            // Able to view task
        }
    
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskInput) as? TaskInputVC{
            vc.displayType = sender.tag == self.addTag ? .add : .view
            vc.orderId = self.orderId
            vc.contactData = self.contactModel.data
            vc.orderInfoDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func editTaskButtonButtonTapped(_ sender: UIButton) {
        if self.appDelegate().userDetails.userRole == .admin || self.appDelegate().userDetails.userRole == .manager || self.appDelegate().userDetails.userRole == .staff {
            // Full access
        }else{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
            return
        }
        
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .taskInput) as? TaskInputVC{
            vc.displayType = .edit
            vc.orderId = self.orderId
            vc.contactData = self.contactModel.data
            vc.orderInfoDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
   
    }
    
    @objc func addProductionButtonTapped(_ sender: UIButton) {
        if  self.appDelegate().userDetails.userRole == .admin ||  self.appDelegate().userDetails.userRole == .manager || self.appDelegate().userDetails.userRole == .staff {
            // Full access
        }else{
            if self.appDelegate().userDetails.userRole == .guest{
                // guestEdit users able to add production
            }else{
                UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                            message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                            target: self)
                return
            }
        }
        
        if let vc = UIViewController.from(storyBoard: .orderInfo, withIdentifier: .addProduction) as? AddProductionVC{
            vc.orderId = self.orderId
            vc.basicInfoData = self.basicInfoModel.data
            vc.isEditProduction = self.isEditProduction
            vc.orderInfoDelegate = self
            vc.totalQuantity = Int(self.basicInfoModel.data?.quantity ?? "") ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
  
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        var vc:UIViewController?
        vc = self.navigationController?.viewControllers.first(where: { (controller) -> Bool in
            return controller.isKind(of: NewOrderVC.self)
        })
        if vc != nil{
            self.navigateToHome()
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func refreshNavigationItemTapped(_ sender: Any) {
        self.getOrderInfo()
    }
   
    override func deleteNavigationItemTapped(_ sender: Any) {
//        self.isDelete = true
//        self.deleteAndCloseOrderText()
        if self.appDelegate().userDetails.userRole == .guest || self.appDelegate().userDetails.userRole == .staff{
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
        }else{
            //self.orderDeleteBackgroundView.isHidden = false
            self.checkCancelOrder()
        }
    }
    
    @objc func deleteOrderButtonTapped(_ sender: UIButton)    {
            self.deleteOrder()
    }
 
    func navigateToHome(){
        let vc = self.navigationController?.viewControllers.first(where: { (controller) -> Bool in
            return controller.isKind(of: TabBarVC.self)
        })
        if vc != nil{
            self.navigationController?.popToViewController(vc!, animated: true)
            return
        }
        
       // NotificationCenter.default.post(name: .reloadNotificationVC, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func backToHomeVC(){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
}

extension OrderInfoVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView{
            return self.dataSource.count
        }else{ // Task progress tableview
            return self.taskDataModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return 1
        }else{// Task progress tableview
            if (self.expandedSectionHeaderNumber == section) {
                return self.taskDataModel[section].task_subtitles.count
            } else {
                return 0;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView{ // Parent tableview
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell") as! BasicInfoTableViewCell
                cell.setContent(data: self.basicInfoModel, target: self)
                return cell
            case 1:
                if self.contactModel.isDataAvailable{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "viewContactCell") as! ViewContactsTableViewCell
                    cell.setContent(target: self)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addContactCell") as! AddContactsTableViewCell
                    cell.setContet(model: self.contactModel, target: self)
                    return cell
                }
            case 2:
                if self.taskModel.isDataAvailable{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "taskProgressCell") as! TaskProgressTableViewCell
                    self.taskTableView = cell.taskTableView
                    if self.taskModel.data.count>0 {
                        cell.taskTableViewHConstraint.constant = CGFloat(self.taskModel.data.count * 100)
                    }else{
                        cell.taskTableViewHConstraint.constant = 0.0
                    }
                    cell.setContent(target: self)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addTaskCell") as! AddTaskTableViewCell
                    cell.setContet(model: self.taskModel, target: self)
                    return cell
                }
            case 3:
                if self.productionModel.isDataAvailable{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "productionContentCell") as! ProductionContentViewTVCell
                    cell.setContet(model: self.productionModel, target: self)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addProductionCell") as! AddProductionTableViewCell
                    cell.setContet(model: self.productionModel,target: self)
                    return cell
                }
            default:
                return UITableViewCell()
            }
        }else{ // Task progress tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskProgressContentCell") as! TaskProgressContentTableViewCell
            cell.setContent(data: self.taskDataModel[indexPath.section].task_subtitles[indexPath.row])
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     
        //recast your view as a UITableViewHeaderFooterView
        if tableView != self.tableView{
    
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = .white
            header.textLabel?.textColor = .customBlackColor()
            
            if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
                viewWithTag.removeFromSuperview()
            }
            let headerFrame = self.taskTableView.frame.size
            let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 20, height: 20));
            theImageView.image = UIImage(named: "ic_collapse-expand")
            theImageView.tintColor = .customBlackColor()
            theImageView.tag = kHeaderSectionTag + section
            header.addSubview(theImageView)
            
            // make headers touchable
            header.tag = section
            let headerTapGesture = UITapGestureRecognizer()
            headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
            header.addGestureRecognizer(headerTapGesture)
        }
       
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView != self.tableView{
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            switch indexPath.section {
            case 0:
                return self.basicInfoModel.isSkuDataAvailable ? self.basicInfoWithSkuCellHeight : self.basicInfoCellHeight
            case 1:
                return self.addContactCellHeight
            case 2:
                if self.taskModel.isDataAvailable{
                    if self.expandedSectionHeaderNumber == -1{
                        return CGFloat((self.taskDataModel.count * 100)+50)
                    }else{
                        return CGFloat(((self.taskDataModel.count * 80) + (self.taskDataModel[expandedSectionHeaderNumber].task_subtitles.count * 80)))
                    }
                }else{
                    return self.addTaskCellHeight
                }
            case 3:
                return self.productionModel.isDataAvailable ? self.productionContentCellHeight : self.addProductionCellHeight
            default:
                break
            }
            return 0.0
        }else{
            return self.taskProgressContentCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.tableView && section == 3{
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
            footerView.backgroundColor = .clear
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.tableView && section == 3{
            return 50.0
        }
        return 0.0
    }
    
    // Collapse progress tableview
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView != self.tableView{
            return self.taskDataModel[section].task_title
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView != self.tableView{
            return 30.0;
        }
        return 0.0
      
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.taskDataModel[section].task_subtitles
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.taskTableView.beginUpdates()
            self.taskTableView.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.taskTableView.endUpdates()
            
           tableView.reloadData()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.taskDataModel[section].task_subtitles
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.taskTableView.beginUpdates()
            self.taskTableView.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.taskTableView.endUpdates()
            
            tableView.reloadData()
        }
    }

}

extension OrderInfoVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == self.contactsCVTag{
            return self.contactModel.data.count
        }else{
            if self.basicInfoModel.skuType == .size{
                return self.basicInfoModel.skuSizeData.count
            }else{
                return self.basicInfoModel.skuColorData.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == self.contactsCVTag{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactsCVCell", for: indexPath) as! ViewContactsCollectionViewCell
            cell.setContent(data: self.contactModel.data[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ccell", for: indexPath) as! SKUDisplayCollectionViewCell
            print(indexPath)
            if self.basicInfoModel.skuType == .size{
                cell.setContent(data: self.basicInfoModel.skuSizeData[indexPath.row], type: self.basicInfoModel.skuType)
            }else{
                cell.setContent(data: self.basicInfoModel.skuColorData[indexPath.row], type: self.basicInfoModel.skuType)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension OrderInfoVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeView = textView
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      
        activeView = nil
        self.view.endEditing(true)
        textView .resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height+50)
        textView.frame = newFrame
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 5000    // 5000 Limit Value
    }
    
}

extension OrderInfoVC: RCOrderInfoDelegate{
    func didReceiveOrderDetailInfo(data: DMSOrderInfoData?){
        self.hideHud()
        if let infoData = data{
            self.bindValues(data: infoData)
        }
    }
    
    func didFailedToReceiveOrderDetailInfo(errorMessage: String){
        self.hideHud()
    }
    
}

extension OrderInfoVC: OrderInfoDataUpdateDelegate{
    func updateOrderInfoData(_ type: OrderInfoDataType, orderInfoData: DMSOrderInfo?) {
        print("_updateOrderInfoData")
        
        self.getOrderInfo()
    }
}

protocol OrderInfoDataSource {
    
}
