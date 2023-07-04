//
//  InquiryListVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 23/01/23.
//

import UIKit
import StoreKit

protocol InquiryBuyerFilterDelegate{
    func filterBuyerInquiryList(filterFactoryId: String, filterArticleId: String, filterStartDate: String, filterEndDate: String)
}
protocol InquiryListDelegate{
    func inquiryList()
}

class InquiryListVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var pageLimit = 10 // Default but after getting from API and assigned
    private var currentPage: Int = 1
    private var lastPage: Int = 1
    
    var pdfURL: String = ""
    var inquiryListData: [InquiryListData]? = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var originalInquiryListData: [InquiryListData]? = []
    var factoryListData: [InquiryFactoryData]? = []
    var articleListData: [InquiryArticlesData]? = []
    var filterFactoryId, filterArticleId, filterStartDate, filterEndDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.inquiryDelegate = self
        self.setupUI()
    
        self.getInquiryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.inquiryDelegate = self
        self.updateFilterNavigationItem()
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key:"viewInquiryText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        
           /* let urlWhats = "whatsapp://send?phone=+918344617217&abid=12354&text=Hello"
                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                    if let whatsappURL = URL(string: urlString) {
                        if UIApplication.shared.canOpenURL(whatsappURL) {
                            UIApplication.shared.openURL(whatsappURL)
                        } else {
                            print("Install Whatsapp")
                            let storeViewController = SKStoreProductViewController()
                              // storeViewController.delegate = self

                               // Set the App Store product identifier for WhatsApp
                               let productParameters = [SKStoreProductParameterITunesItemIdentifier: "310633997"] // WhatsApp's App Store ID
                               storeViewController.loadProduct(withParameters: productParameters)

                            print(storeViewController)
                               present(storeViewController, animated: true, completion: nil)
                        }
                    }
                }*/
    }

    func getInquiryList(factoryId: String = "",
                        articleId: String = "",
                        startDate: String = "",
                        endDate: String = "") {
        self.showHud()
        var params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "user_id": RMConfiguration.shared.userId,
                                      "page": currentPage]
        if factoryId != "0"{
            params["factory_id"] = factoryId
        }
        if articleId != "0"{
            params["article_id"] = articleId
        }
        if startDate != ""{
            params["from_date"] = startDate
        }
        if endDate != ""{
            params["to_date"] = endDate
        }

        print(params)
        RestCloudService.shared.getInquiryList(params: params)
    }
    
    func updateFilterNavigationItem(){
        if self.filterFactoryId?.count ?? 0 > 0 || self.filterArticleId?.count ?? 0 > 0 || self.filterStartDate?.count ?? 0 > 0 || self.filterEndDate?.count ?? 0 > 0{
            self.addNavigationItem(type: [.filterApply], align: .right)
        }else{
            self.addNavigationItem(type: [.filter], align: .right)
        }
    }
    
    func readInquiryNotification( inquiryId: String ) {
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId,
                                     "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.readInquiryNotification(params: params)
    }
    
    @objc func inquiryDownloadButtonTapped(_ sender: UIButton) {
        
        self.showHud()
        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{

                        DispatchQueue.main.async {
                            
                            if hasCell.data?.notification != nil{
                                if let index = hasCell.index{
                                    print(index)
                                    self.inquiryListData?[index].notification = nil
                                    self.tableView.reloadData()
                                }
                                self.readInquiryNotification(inquiryId: "\(hasCell.inquiryId ?? "0")")
                            }
                            
                            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .pdfView) as? PDFViewVC {
                                print("\(self.pdfURL)\(hasCell.inquiryId ?? "").pdf")
                                vc.pdfURL = "\(self.pdfURL)\(hasCell.inquiryId ?? "").pdf".removingWhitespaces()
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
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{
                     
                        // Update notification
                        if hasCell.data?.notification != nil{
                            if let index = hasCell.index{
                                self.inquiryListData?[index].notification = nil
                                self.tableView.reloadData()
                            }
                        }
                        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .factoryResponse) as? FactoryResponseVC {
                            vc.isFromDashboard = false
                            vc.inquiryId = hasCell.inquiryId ?? ""
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        }
       
    }
    
    @objc func addFactoryContactButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{
                        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryFactoryContact) as? InquiryFactoryContactVC {
                            vc.inquiryId = hasCell.inquiryId ?? ""
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    @objc func addSentToInquiryButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{
                        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryFactoryContact) as? InquiryFactoryContactVC {
                            vc.inquiryId = hasCell.inquiryId
                            vc.isSentTo = true
                            vc.inquiryListDelegate = self
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        }
    }
    
    @objc func inquiryDeleteButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{
                        
                        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "areYouSureText"),
                                                    message: "\(LocalizationManager.shared.localizedString(key: "doYouWantToDeleteInquiryText")) IN-\(hasCell.inquiryId ?? "")",
                                                    firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                                    secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                                    target: self) { (status) in
                            if status == false{
                                
                                self.showHud()
                                let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                                              "inquiry_id": hasCell.inquiryId ?? ""]
                                print(params)
                                RestCloudService.shared.deleteInquiry(params: params)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func filterNavigationItemTapped(_ sender: UIBarButtonItem) {
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryFilter) as? InquiryFilterVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.factoryListData = self.factoryListData
            vc.articleListData = self.articleListData
           
            vc.filterArticleId = self.filterArticleId
            vc.filterFactoryId = self.filterFactoryId
            vc.filterStartDate = self.filterStartDate
            vc.filterEndDate = self.filterEndDate
            vc.filterBuyerDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
      
    }
    
}

extension InquiryListVC : UITableViewDataSource, UITableViewDelegate{
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InquiryListTableViewCell
        
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
                self.getInquiryList(factoryId: self.filterFactoryId ?? "",
                                    articleId: self.filterArticleId ?? "",
                                    startDate: self.filterStartDate ?? "",
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

extension InquiryListVC: RCInquiryDelegate{
   
    /// Get InquiryList
    func didReceiveInquiryList(data: InquiryListResponse?){
        self.hideHud()
        
        if let inquiryData =  data?.data?.data{
            self.inquiryListData?.append(contentsOf: inquiryData)
            self.originalInquiryListData?.append(contentsOf: inquiryData)
            
            self.currentPage = self.currentPage + 1
            self.pageLimit = data?.data?.per_page ?? 0
            self.lastPage = data?.data?.last_page ?? 1
        }
      
        self.pdfURL = data?.pdfpath ?? ""
        self.factoryListData = data?.factories
        self.articleListData = data?.articles
     
        if self.currentPage > 2{
            self.hideBottomLoader()
        }
    }
    
    func didFailedToReceiveInquiryList(errorMessage: String){
        self.hideHud()
        self.hideBottomLoader()
    }
    
    /// Read Inquiry Notification Response
    func didReceiveReadInquiryNotificationResponse(message: String){
        self.hideHud()
    }
    func didFailedToReadInquiryNotificationResponse(errorMessage: String){
        self.hideHud()
    }
    
    // Delete inquiry
    func didReceiveDeleteInquiry(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
               
                // set initial values
                self.currentPage = 1
                self.inquiryListData = []
                
                self.getInquiryList()
            }
        })
    }
    func didFailedToReceiveDeleteInquiry(errorMessage: String){
        self.hideHud()
    }
}

extension InquiryListVC: InquiryBuyerFilterDelegate{
    func filterBuyerInquiryList(filterFactoryId: String, filterArticleId: String, filterStartDate: String, filterEndDate: String){
        print(filterFactoryId, filterArticleId, filterStartDate, filterEndDate)
        self.filterFactoryId = filterFactoryId == "0" ? "" : filterFactoryId
        self.filterArticleId = filterArticleId == "0" ? "" : filterArticleId
        self.filterStartDate = filterStartDate
        self.filterEndDate = filterEndDate
        
        self.updateFilterNavigationItem()
        
        if self.filterFactoryId == "" && self.filterArticleId == "" && self.filterStartDate == "" && self.filterEndDate == ""{
            self.inquiryListData = self.originalInquiryListData
            return
        }
      
        // set initial values
        self.currentPage = 1
        self.inquiryListData = []
        
        self.getInquiryList(factoryId: filterFactoryId,
                            articleId: filterArticleId,
                            startDate: filterStartDate,
                            endDate: filterEndDate )
    }

}

extension InquiryListVC: InquiryListDelegate{
    func inquiryList(){
        RestCloudService.shared.inquiryDelegate = self
        // set initial values
        self.currentPage = 1
        self.inquiryListData = []
        
        self.getInquiryList()
    }
}
