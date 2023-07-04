//
//  InquiryStatusVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 28/01/23.
//

import UIKit

protocol InquiryFactoryFilterDelegate{
    func filterFactoryInquiryList(filterUserId: String, filterArticleId: String, filterStartDate: String, filterEndDate: String)
}


class InquiryStatusVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var pageLimit = 10 // Default but after getting from API and assigned
    private var currentPage: Int = 0
    private var lastPage: Int = 1
    
    var pdfURL: String = ""
    var factoryResponse: [Int] = []
    var inquiryListData: [FactoryInquiryResponseData]? = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var originalInquiryListData: [FactoryInquiryResponseData]? = []
    var userListData: [InquiryArticlesData]? = []
    var articleListData: [InquiryArticlesData]? = []
    var filterUserId, filterArticleId, filterStartDate, filterEndDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.inquiryDelegate = self
        self.setupUI()
        self.getFactoryInquiryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.inquiryDelegate = self
        self.updateFilterNavigationItem()
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key: "inquiryStatusText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }

    func updateFilterNavigationItem(){
        if self.filterUserId?.count ?? 0 > 0 || self.filterArticleId?.count ?? 0 > 0 || self.filterStartDate?.count ?? 0 > 0 || self.filterEndDate?.count ?? 0 > 0{
            self.addNavigationItem(type: [.filterApply], align: .right)
        }else{
            self.addNavigationItem(type: [.filter], align: .right)
        }
    }
    
    func getFactoryInquiryList(userId: String = "",
                               articleId: String = "",
                               startDate: String = "",
                               endDate: String = "",
                               currentPage: Int = 1) {
        self.showHud()
        var params:[String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                     "workspace_id": RMConfiguration.shared.workspaceId,
                                     "factory_id": RMConfiguration.shared.userId,
                                     "page": currentPage]
      
        params["user_id"] = userId != "0" ? userId : ""
        params["article_id"] = articleId != "0" ? articleId : ""
        params["from_date"] = startDate != "" ? startDate : ""
        params["to_date"] = endDate != "" ? endDate : ""
     
        print(params)
        RestCloudService.shared.getFactoryInquiryList(params: params)
    }
    
    @objc func viewQuoteButtonTapped(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview{
                    if let hasCell = mainView.superview as? InquiryStatusTableViewCell{
                  
                        if hasCell.data?.is_read == 0 {
                            hasCell.data?.is_read = 1
                            self.tableView.reloadData()
                            self.readInquiryNotification(inquiryId: "\(hasCell.inquiryId ?? "0")")
                        }
                      
                        if hasCell.isPending == false{
                            self.gotoPDFViewVC(pdfURL: "\(self.pdfURL)\(hasCell.inquiryId ?? "").pdf")
                  
                        }else{

                            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .sendQuotation) as? SendQuotationVC {
                                vc.isFromDashboard = false
                                vc.pdfURL = "\(self.pdfURL)\(hasCell.inquiryId ?? "").pdf"
                                vc.inquiryId = hasCell.inquiryId ?? ""
                                vc.factoryInquiryData = hasCell.data
                                vc.delegate = self
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
                if let mainView = bottomView.superview{
                    if let hasCell = mainView.superview as? InquiryListTableViewCell{
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
  
    func readInquiryNotification( inquiryId: String ) {
        self.showHud()
        let params:[String:Any] =  [ "inquiry_id": inquiryId,
                                     "user_id": RMConfiguration.shared.userId ]
        print(params)
        RestCloudService.shared.readInquiryNotification(params: params)
    }
     
    func gotoPDFViewVC(pdfURL: String){
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .pdfView) as? PDFViewVC {
                vc.pdfURL = pdfURL
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    override func filterNavigationItemTapped(_ sender: UIBarButtonItem) {
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .inquiryFilter) as? InquiryFilterVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.userListData = self.userListData
            vc.articleListData = self.articleListData
           
            vc.filterArticleId = self.filterArticleId
            vc.filterFactoryId = self.filterUserId
            vc.filterStartDate = self.filterStartDate
            vc.filterEndDate = self.filterEndDate
            vc.filterFactoryDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
      
    }
}

extension InquiryStatusVC : UITableViewDataSource, UITableViewDelegate{
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InquiryStatusTableViewCell
        
        // 9
        switch section {
        case .inquiryList:
            if let data = self.inquiryListData?[indexPath.row]{
                cell.setContent(data: data, response: self.factoryResponse, target: self)
            }
            return cell

        case .loader:
            if currentPage < lastPage{
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
            if currentPage < lastPage{
                self.getFactoryInquiryList(userId: self.filterUserId ?? "",
                                           articleId: self.filterArticleId ?? "",
                                           startDate: self.filterStartDate ?? "",
                                           endDate: self.filterEndDate ?? "",
                                           currentPage: self.currentPage + 1)
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
            return 200
        case .loader:
            return currentPage < lastPage ? 50 : 0
        }
    }
}

extension InquiryStatusVC: RCInquiryDelegate{
  
    /// Get Factory InquiryList
    func didReceiveFactoryInquiryList(data: FactoryInquiryResponse?, response: [Int]?){
        self.hideHud()
        if let inquiryData = data?.data?.data{
            self.inquiryListData?.append(contentsOf: inquiryData)
            self.originalInquiryListData?.append(contentsOf: inquiryData)
            
            self.currentPage = data?.data?.current_page ?? 1
            self.pageLimit = data?.data?.per_page ?? 0
            self.lastPage = data?.data?.last_page ?? 1
        }
        
//        if self.currentPage > 2{
//            self.hideBottomLoader()
//        }
        
        self.pdfURL = data?.pdfPath ?? ""
        self.factoryResponse = data?.response ?? []
        self.userListData = data?.users
        self.articleListData = data?.articles
    }
    
    func didFailedToReceiveFactoryInquiryList(errorMessage: String){
        self.hideHud()
    }
    
    /// Read Inquiry Notification Response
    func didReceiveReadInquiryNotificationResponse(message: String){
        self.hideHud()
    }
    func didFailedToReadInquiryNotificationResponse(errorMessage: String){
        self.hideHud()
    }
}

extension InquiryStatusVC: inquiryStatusProtocol{
    func callInquiryStatusList() {
        // set initial values
        self.inquiryListData = []
        self.getFactoryInquiryList(userId: self.filterUserId ?? "",
                                   articleId: self.filterArticleId ?? "",
                                   startDate: self.filterStartDate ?? "",
                                   endDate: self.filterEndDate ?? "",
                                   currentPage: self.currentPage)
    }
}

extension InquiryStatusVC: InquiryFactoryFilterDelegate{
    func filterFactoryInquiryList(filterUserId: String, filterArticleId: String, filterStartDate: String, filterEndDate: String){
        print("userid:",filterUserId,"articleid:", filterArticleId,"startdate:", filterStartDate,"enddate:", filterEndDate)
        self.filterUserId = filterUserId == "0" ? "" : filterUserId
        self.filterArticleId = filterArticleId == "0" ? "" : filterArticleId
        self.filterStartDate = filterStartDate
        self.filterEndDate = filterEndDate
        
        self.updateFilterNavigationItem()
        if  self.filterUserId == "" && self.filterArticleId == "" && self.filterStartDate == "" && self.filterEndDate == ""{
            self.inquiryListData = self.originalInquiryListData
            return
        }
      
        // set initial values
        self.currentPage = 0
        self.inquiryListData = []
        
        self.getFactoryInquiryList(userId: filterUserId,
                            articleId: filterArticleId,
                            startDate: filterStartDate,
                            endDate: filterEndDate,
                            currentPage: self.currentPage )

    }

}
