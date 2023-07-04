//
//  AddViewSuppliersResponseVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 29/03/23.
//

import UIKit

protocol ViewFabricSuppliersDelegate{
    func ViewFabricSuppliersList()
}

class AddViewSuppliersResponseListVC: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var inquiryNoTitleLabel: UILabel!
    @IBOutlet var inquiryNoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNewSuppliersButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewHConstraint: NSLayoutConstraint!
    
    // External Data
    var inquiryId: String?
    var isSentTo: Bool = false
    
    var supplierData: [FabricSupplierData] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var fabricSupplierListData: [FabricSupplierListData] = []
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RestCloudService.shared.fabricDelegate = self
        self.setupUI()
        self.getSuppliersResponse()
        self.getSuppliersListResponse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.fabricDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .fabric)
        self.title = LocalizationManager.shared.localizedString(key:"suppliersResponseText")
    }
    
    func setupUI(){
        
        self.mainView.backgroundColor = UIColor(rgb: 0xF2F4F3)
        self.topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
       
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        
        self.addNewSuppliersButton.backgroundColor = .fabricPrimaryColor()
        self.addNewSuppliersButton.layer.cornerRadius = self.addNewSuppliersButton.frame.height / 2.0
        self.addNewSuppliersButton.setTitleColor(.white, for: .normal)
        self.addNewSuppliersButton.setTitle("+ \(LocalizationManager.shared.localizedString(key: "addSupplierResponseText"))", for: .normal)
        self.addNewSuppliersButton.addTarget(self, action: #selector(addNewSuppliersButtonTapped(_:)), for: .touchUpInside)
    
        self.inquiryNoTitleLabel.text = "\(LocalizationManager.shared.localizedString(key:"inquiryNoText")): "
        self.inquiryNoLabel.text = "IN-\(inquiryId ?? "")"
        
        self.stackView.isHidden = isSentTo == true ? true : false
        self.stackViewHConstraint.constant = isSentTo == true ? 0.0 : 40.0
        
        // For view supplier response Permission
       if RMConfiguration.shared.loginType == Config.Text.staff && self.appDelegate().workspaceDetails.currentWorkspace?.permissions?.contains(Permissions.addSupplierResponse.rawValue) == false {
           self.addNewSuppliersButton.isHidden = true
           self.stackViewHConstraint.constant = 0
       }
    }
//
//    private func getFabricContactList(){
//        self.showHud()
//        RestCloudService.shared.getFabricContact(params: [:])
//    }
 
    private func getSuppliersResponse(){
        self.showHud()
        let params:[String:Any] =  ["inquiry_id": self.inquiryId ?? "",
                                    "user_id": RMConfiguration.shared.userId]
        print(params)
        RestCloudService.shared.getSuppliersResponse(params: params)
    }
 
    private func getSuppliersListResponse(){
        self.showHud()
        let params:[String:Any] =  ["inquiry_id": self.inquiryId ?? ""]
        print(params)
        RestCloudService.shared.getSuppliersListResponse(params: params)
    }
    
    @objc func addNewSuppliersButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .fabric, withIdentifier: .addSupplierResponse) as? AddSupplierResponseVC {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.fabricSupplierListData = self.fabricSupplierListData
            vc.inquiryId = self.inquiryId
            vc.currency = self.currency
            vc.supplierResponseDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
  
}

extension AddViewSuppliersResponseListVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.supplierData.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SupplierResponseTableViewCell
        cell.setContent(index: indexPath.row,
                        data: self.supplierData[indexPath.row],
                        target: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension AddViewSuppliersResponseListVC: RCFabricDelegate{
    
    // Get suppliers response list
    func didReceiveGetSuppliersResponse(data: [FabricSupplierData]?){
        self.hideHud()
        if let supplierData = data{
            self.supplierData = supplierData
        }
    }
    func didFailedToReceiveGetSuppliersResponse(errorMessage: String){
        self.hideHud()
    }
 
    // Get suppliers List response
    func didReceiveGetSuppliersListResponse(data: [FabricSupplierListData]?, currency: String){
        self.hideHud()
        if let supplierListData = data{
            self.fabricSupplierListData = supplierListData
            self.stackView.isHidden = fabricSupplierListData.count == 0 ? true : false
            self.stackViewHConstraint.constant = fabricSupplierListData.count == 0 ? 0.0 : 40.0
        }
        self.currency = currency
    }
    func didFailedToReceiveGetSuppliersListResponse(errorMessage: String){
        self.hideHud()
    }
}

extension AddViewSuppliersResponseListVC: ViewFabricSuppliersDelegate{
    func ViewFabricSuppliersList(){
        RestCloudService.shared.fabricDelegate = self
        self.getSuppliersListResponse()
        self.getSuppliersResponse()
    }
}
