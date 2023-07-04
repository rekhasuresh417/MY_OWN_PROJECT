//
//  PurchaseOrderListVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 13/04/23.
//

import UIKit

class PurchaseOrderListVC: UIViewController {

    @IBOutlet var tableView: UITableView!
   
    var pdfPath: String = ""
    
    var purchaseOrderList: [PurchaseOrderListData]? = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestCloudService.shared.purchaseOrderDelegate = self
        self.setupUI()
        
        self.getInquiryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.purchaseOrderDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = LocalizationManager.shared.localizedString(key:"viewPOText")
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor(rgb: 0xF3F3F3)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }
    
    func getInquiryList() {
        self.showHud()
        let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                      "workspace_id": RMConfiguration.shared.workspaceId,
                                      "page": 1]
        print(params)
        RestCloudService.shared.getPurchaseOrderList(params: params)
    }
   
    @objc func viewPOButtonTapped(_ sender: UIButton) {
        if RMConfiguration.shared.loginType == Config.Text.user || self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.viewPO.rawValue) == true {
            // permission grated
            DispatchQueue.main.async {
                if let bottomView = sender.superview?.superview{
                    if let mainView = bottomView.superview?.superview{
                        if let hasCell = mainView.superview as? PurchaseOrderListTableViewCell{
                            
                            if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .pdfView) as? PDFViewVC {
                                vc.pdfURL = "\(self.pdfPath)\(hasCell.data?.po_id ?? 0).pdf".removingWhitespaces()
                                vc.isFrom = "PO"
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                            
                        }
                    }
                }
            }
        }else { // permission denied
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "accessDeniedTitleText"),
                                        message: LocalizationManager.shared.localizedString(key: "accessDeniedMessageText"),
                                        target: self)
        }
    
    }
  
    @objc func cancelPOButtonTapped(_ sender: UIButton) {

        DispatchQueue.main.async {
            if let bottomView = sender.superview?.superview{
                if let mainView = bottomView.superview?.superview{
                    if let hasCell = mainView.superview as? PurchaseOrderListTableViewCell {
                        
                        UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "cancelPOConfirmationText"),
                                                    message: "",
                                                    firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                                    secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                                    target: self) { (status) in
                            if status == false{
                                
                                self.showHud()
                                let params: [String:Any] =  [ "company_id": RMConfiguration.shared.companyId,
                                                              "workspace_id": RMConfiguration.shared.workspaceId,
                                                              "po_id": hasCell.data?.po_id ?? ""]
                                print(params)
                                RestCloudService.shared.cancelPurchaseOrder(params: params)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension PurchaseOrderListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.purchaseOrderList?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PurchaseOrderListTableViewCell
            if let data = self.purchaseOrderList?[indexPath.row]{
                cell.setContent(data: data, target: self)
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}

extension PurchaseOrderListVC: RCPurchaseOrderDelegate{
   
    /// Get Purchase Order List
    func didReceivePurchaseOrderList(data: PurchaseOrderList?){
        self.hideHud()
        if let poData = data?.data?.data{
            self.purchaseOrderList = poData
        }
        self.pdfPath = data?.pdfpath ?? ""
    }
    func didFailedToReceivePurchaseOrderList(errorMessage: String){
        self.hideHud()
    }
    
    /// Cancel Purchase Order
    func didReceiveCancelPurchaseOrder(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.getInquiryList()
            }
        })
    }
    func didFailedToReceiveCancelPurchaseOrder(errorMessage: String){
        self.hideHud()
    }
}
