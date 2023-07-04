//
//  FabricInquiryListVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 15/03/23.
//

import UIKit

protocol FabricInquiryFilterDelegate{
    func filterFabricInquiryList(filterStartDate: String, filterEndDate: String)
}

protocol FabricInquiryListDelegate{
    func fabricInquiryList()
}

class FabricInquiryListVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNewFabricInquiryButton: UIButton!
    @IBOutlet var addFabricInquiryButtonHConstraint: NSLayoutConstraint!
    
    private var pageLimit = 10 // Default but after getting from API and assigned
    private var currentPage: Int = 1
    private var lastPage: Int = 1
    
    var pdfURL: String = ""
    var inquiryListData: [FabricInquiryListData]? = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var filterStartDate, filterEndDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
    
        self.getInquiryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.fabricDelegate = self
        self.updateFilterNavigationItem()
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .fabric)
        self.title = LocalizationManager.shared.localizedString(key:"viewInquiryText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        self.addNewFabricInquiryButton.backgroundColor = .fabricPrimaryColor()
        self.addNewFabricInquiryButton.layer.cornerRadius = self.addNewFabricInquiryButton.frame.height / 2.0
        self.addNewFabricInquiryButton.setTitle(LocalizationManager.shared.localizedString(key: "addFabricInquiryText"), for: .normal)
        self.addNewFabricInquiryButton.addTarget(self, action: #selector(addFabricInquiryButtonTapped(_:)), for: .touchUpInside)
        
        // For Add Fabric Inquiry Permission
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addFabricInquiry.rawValue) == true {
            self.addNewFabricInquiryButton.isHidden = false
            self.addFabricInquiryButtonHConstraint.constant = 50.0
        }else{
            self.addNewFabricInquiryButton.isHidden = true
            self.addFabricInquiryButtonHConstraint.constant = 0.0
        }
    }

    func getInquiryList(startDate: String = "",
                        endDate: String = "") {
        self.showHud()
        var params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "user_id": RMConfiguration.shared.userId,
                                      "page": currentPage]
        if startDate != ""{
            params["from_date"] = startDate
        }
        if endDate != ""{
            params["to_date"] = endDate
        }

        print(params)
        RestCloudService.shared.getFabricList(params: params)
    }
    
    func updateFilterNavigationItem(){
        if self.filterStartDate?.count ?? 0 > 0 || self.filterEndDate?.count ?? 0 > 0{
            self.addNavigationItem(type: [.filterApply], align: .right)
        }else{
            self.addNavigationItem(type: [.filter], align: .right)
        }
    }
  
    @objc func inquiryDownloadButtonTapped(_ sender: UIButton) {
        
        self.showHud()
        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{

                        DispatchQueue.main.async {
                            
                            if hasCell.data?.notification != nil{
                                if let index = hasCell.index{
                                    print(index)
                                    self.tableView.reloadData()
                                }
                            }
                            
                            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .pdfView) as? PDFViewVC {
                                vc.pdfURL = "\(self.pdfURL)\(hasCell.inquiryId ?? "").pdf"
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                        }
                    }
                }
            }
        }
    
    }
    
    @objc func inquiryViewButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                if let stackView = sender.superview{
                    if let bottomView = stackView.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? FabricInquiryListTableViewCell{
                                    
                                    if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .detailsFabricInquiry) as? DetailsFabricInquiryVC {
                                        vc.inquiryId = hasCell.inquiryId
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func inquiryEditButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                if let stackView = sender.superview{
                    if let bottomView = stackView.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? FabricInquiryListTableViewCell{
                                    
                                    if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .createNewFabricInquiry) as? CreateNewFabricInquiryVC{
                                        vc.isEdit = true
                                        vc.fabricInquiryDelegate = self
                                        vc.inquiryId = hasCell.inquiryId
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func inquiryAddButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                if let stackView = sender.superview{
                    if let bottomView = stackView.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? FabricInquiryListTableViewCell{
                                    
                                    if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .selectFabricSuppliers) as? SelectFabricSuppliersVC{
                                        vc.inquiryId = hasCell.inquiryId
                                        vc.fabricInquiryDelegate = self
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func inquiryDeleteButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                if let stackView = sender.superview{
                    if let bottomView = stackView.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? FabricInquiryListTableViewCell{
                                
                                    UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "areYouSureDeleteText"),
                                                                message: "",
                                                                firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                                                secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                                                target: self) { (status) in
                                        if status == false{
                                            
                                            self.showHud()
                                            let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                                                          "inquiry_id": hasCell.inquiryId ?? ""]
                                            print(params)
                                            RestCloudService.shared.deleteFabricInquiry(params: params)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func inquirySendToButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                if let stackView = sender.superview{
                    if let bottomView = stackView.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? FabricInquiryListTableViewCell{
                                    
                                    if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .selectFabricSuppliers) as? SelectFabricSuppliersVC{
                                        vc.inquiryId = hasCell.inquiryId
                                        vc.isSentTo = true
                                        vc.fabricInquiryDelegate = self
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func inquiryResponseButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                if let stackView = sender.superview{
                    if let bottomView = stackView.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? FabricInquiryListTableViewCell{
                                    
                                    if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .addViewSuppliersResponse) as? AddViewSuppliersResponseListVC{
                                        vc.inquiryId = hasCell.inquiryId
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
 
    override func filterNavigationItemTapped(_ sender: UIBarButtonItem) {
        if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .fabricInquiryFilter) as? FabricInquiryFilterVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
       
            vc.filterStartDate = self.filterStartDate
            vc.filterEndDate = self.filterEndDate
            vc.filterFabricDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
  
    @objc func addFabricInquiryButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .createNewFabricInquiry) as? CreateNewFabricInquiryVC{
            vc.fabricInquiryDelegate = self
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    // set initial values
    func setInitialValue(){
        self.inquiryListData = []
        self.currentPage = 1
    }
}

extension FabricInquiryListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .inquiryList:
            return tableView.updateNumberOfRow(self.inquiryListData?.count ?? 0)
        case .loader:
            return tableView.updateNumberOfRow(self.inquiryListData?.count ?? 0) >= pageLimit ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FabricInquiryListTableViewCell
        
        // 9
        switch section {
        case .inquiryList:
            if let data = self.inquiryListData?[indexPath.row]{
                cell.setContent(index:indexPath.row, data: data, target: self)
            }
            return cell

        case .loader:
            if currentPage <= lastPage{
                let cell1 = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell1.textLabel?.text = "Loading.."
                cell1.textLabel?.textAlignment = .center
                cell1.textLabel?.textColor = .inquiryPrimaryColor()
                return cell1
            }else{
                return UITableViewCell()
            }
        }

    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !(inquiryListData?.isEmpty ?? false) else { return }
        
        if section == .loader {
            print("load new data..")
            if currentPage <= lastPage{
                self.getInquiryList(startDate: self.filterStartDate ?? "",
                                    endDate: self.filterEndDate ?? "")
            }
        }
    }
    
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: (self.inquiryListData?.count ?? 0) - 1, section: TableSection.inquiryList.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = TableSection(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .inquiryList:
            return UITableView.automaticDimension
        case .loader:
            return currentPage <= lastPage ? 50 : 0
        }
    }
}

extension FabricInquiryListVC: RCFabricDelegate{
   
    /// Get Fabric Inquiry List
    func didReceiveFabricInquiryList(data: FabricInquiryListResponse?){
        self.hideHud()
        
        if let inquiryData =  data?.data?.data{
            
            self.inquiryListData?.append(contentsOf: inquiryData)
    
            self.currentPage = self.currentPage + 1
            self.pageLimit = data?.data?.per_page ?? 0
            self.lastPage = data?.data?.last_page ?? 1
        }
      
        self.pdfURL = data?.pdfpath ?? ""
    
        if self.currentPage > 2{
            self.hideBottomLoader()
        }
    }
    
    func didFailedToReceiveFabricInquiryList(errorMessage: String){
        self.hideHud()
        self.hideBottomLoader()
    }
 
    // Delete fabric inquiry
    func didReceiveDeleteFabricInquiry(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.setInitialValue()
                self.getInquiryList()
            }
        })
    }
    func didFailedToReceiveDeleteFabricInquiry(errorMessage: String){
        self.hideHud()
    }
    
}

extension FabricInquiryListVC: FabricInquiryFilterDelegate{
    func filterFabricInquiryList(filterStartDate: String, filterEndDate: String) {
        self.filterStartDate = filterStartDate
        self.filterEndDate = filterEndDate
        
        self.updateFilterNavigationItem()
        
        // set initial values
        self.setInitialValue()
        
        self.getInquiryList(startDate: filterStartDate,
                            endDate: filterEndDate)
    }
    
}

extension FabricInquiryListVC: FabricInquiryListDelegate{
    func fabricInquiryList(){
        RestCloudService.shared.fabricDelegate = self
        self.setInitialValue()
        self.getInquiryList()
    }
}

