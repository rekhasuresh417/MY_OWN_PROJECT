//
//  InquiryFactoryContactVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 12/04/23.
//

import UIKit

protocol AddFactoryContactsDelegate{
    func AddFactoryContactsList()
}

class InquiryFactoryContactVC: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var inquiryNoTitleLabel: UILabel!
    @IBOutlet var inquiryNoLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addNewSuppliersButton: UIButton!
    @IBOutlet var sendToSuppliersButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewHConstraint: NSLayoutConstraint!
    
    // External Data
    var inquiryId: String?
    var isSentTo: Bool = false
    var inquiryListDelegate: InquiryListDelegate?
    
    var contactData: [InquiryFactoryListData] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var selectedContactData: [InquiryFactoryListData] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var tempSelectedContactData: [InquiryFactoryListData] = []
    var recentlySelectedContactData: [InquiryFactoryListData] = []
    var inquiryDelegate: InquiryListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RestCloudService.shared.factoryContactDelegate = self
        self.setupUI()
        self.getInquiryFactoryList()
        self.getInquiryFactory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.factoryContactDelegate = self
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        self.title = isSentTo == true ? LocalizationManager.shared.localizedString(key:"inquirySentToText") : LocalizationManager.shared.localizedString(key:"selectFactoryContactText")
    }
    
    func setupUI(){
        
        self.mainView.backgroundColor = UIColor(rgb: 0xF2F4F3)
        self.topView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
       
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = .clear
        
        self.addNewSuppliersButton.backgroundColor = .inquiryPrimaryColor()
        self.addNewSuppliersButton.layer.cornerRadius = self.addNewSuppliersButton.frame.height / 2.0
        self.addNewSuppliersButton.setTitleColor(.white, for: .normal)
        self.addNewSuppliersButton.setTitle(LocalizationManager.shared.localizedString(key: "addNewFactoryText"), for: .normal)
        self.addNewSuppliersButton.addTarget(self, action: #selector(addNewSuppliersButtonTapped(_:)), for: .touchUpInside)
    
        self.sendToSuppliersButton.backgroundColor = .inquiryPrimaryColor()
        self.sendToSuppliersButton.layer.cornerRadius = self.sendToSuppliersButton.frame.height / 2.0
        self.sendToSuppliersButton.setTitleColor(.white, for: .normal)
        self.sendToSuppliersButton.setTitle(LocalizationManager.shared.localizedString(key: "sendInquiryText"), for: .normal)
        self.sendToSuppliersButton.addTarget(self, action: #selector(sendToSuppliersButtonTapped(_:)), for: .touchUpInside)
        
        self.inquiryNoTitleLabel.text = "\(LocalizationManager.shared.localizedString(key:"inquiryNoText")): "
        self.inquiryNoLabel.text = "IN-\(inquiryId ?? "")"
        self.stackView.isHidden = isSentTo == true ? true : false
        self.stackViewHConstraint.constant = isSentTo == true ? 0.0 : 40.0
    }
  
    private func getInquiryFactoryList(){
        self.showHud()
        let params:[String:Any] =  ["inquiry_id": self.inquiryId ?? ""]
        print(params)
        RestCloudService.shared.getInquiryFactoryList(params: params)
    }
    
    private func getInquiryFactory(){
        self.showHud()
        RestCloudService.shared.getInquiryFactory(params: [:])
    }
    
    private func sendToSuppliersList(){
        if recentlySelectedContactData.count > 0{
            self.showHud()
            var suppliersIds: [Int] = []
            for data in recentlySelectedContactData{
                suppliersIds.append(data.id ?? 0)
            }
            
            let params:[String:Any] =  ["inquiry_id": self.inquiryId ?? "",
                                        "factory_id": suppliersIds,
                                        "user_id": RMConfiguration.shared.userId,
                                        "company_id": RMConfiguration.shared.companyId]
            print(params)
            RestCloudService.shared.sendInquiryToFactory(params: params)
        }else{
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key:"selectFactoryText"), target: self)
        }
    
    }
    
    @objc func checkBoxSelection(_ sender: UIButton) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                    if let bottomView = sender.superview{
                        if let mainView = bottomView.superview{
                            if let contentView = mainView.superview{
                                if let hasCell = contentView.superview as? InquiryFactoryContactTableViewCell{
                                    
                                    let selectedIndexPath = hasCell.index
                                    let containData = self.selectedContactData.filter({$0.id == self.contactData[selectedIndexPath].id})
                                    if containData.count > 0{
                                        self.selectedContactData = self.selectedContactData.filter({$0.id != self.contactData[selectedIndexPath].id})
                                    }else{
                                        self.selectedContactData.append(self.contactData[selectedIndexPath])
                                    }
                                   
                                    // recentlySelectedContactData
                                    let containsData = self.recentlySelectedContactData.filter({$0.id == self.contactData[selectedIndexPath].id})
                                    if containsData.count > 0{
                                        self.recentlySelectedContactData = self.recentlySelectedContactData.filter({$0.id != self.contactData[selectedIndexPath].id})
                                    }else{
                                        self.recentlySelectedContactData.append(self.contactData[selectedIndexPath])
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    @objc func addNewSuppliersButtonTapped(_ sender: UIButton) {
        if let vc = UIViewController.from(storyBoard: .inquiry, withIdentifier: .addFactoryContact) as? AddFactoryContactVC {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.factoriesDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func sendToSuppliersButtonTapped(_ sender: UIButton) {
        self.sendToSuppliersList()
    }
    
}

extension InquiryFactoryContactVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.contactData.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InquiryFactoryContactTableViewCell
        cell.setContent(index: indexPath.row,
                        data: self.contactData[indexPath.row],
                        selectedData: self.selectedContactData,
                        tempSelectedData: self.tempSelectedContactData,
                        isSent: self.isSentTo ,
                        target: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension InquiryFactoryContactVC: RCFactoryContactDelegate{
   
    /// Get Inquiry Factory List
    func didReceiveInquiryFactoryList(data: [InquiryFactoryListData]?){
        self.hideHud()
        if let selectedData = data{
            self.selectedContactData = selectedData
            self.tempSelectedContactData = selectedData
        }
    }
    func didFailedToReceiveInquiryFactoryList(errorMessage: String){
        self.hideHud()
    }
    
    /// Get Inquiry Factory
    func didReceiveInquiryFactory(data: [InquiryFactoryListData]?){
        self.hideHud()
        if let contactData = data{
            self.contactData = self.isSentTo == true ? self.selectedContactData : contactData
        }
    }
    func didFailedToReceiveInquiryFactory(errorMessage: String){
        self.hideHud()
    }
 
    // Send factory Inquiry
    func didReceiveSendFactoryInquiry(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.inquiryDelegate?.inquiryList()
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    func didFailedToReceiveSendFactoryInquiry(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: String().getAlertSuccess(message: errorMessage), target: self)
    }
}

extension InquiryFactoryContactVC : AddFactoryContactsDelegate{
    func AddFactoryContactsList() {
        RestCloudService.shared.factoryContactDelegate  = self
        self.getInquiryFactory()
    }
}
