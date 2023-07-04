//
//  ContactListVC.swift
//  Itohen-dms
//
//  Created by Dharma on 18/01/21.
//

import UIKit

class ContactListVC: UIViewController{

    @IBOutlet var tableView:UITableView!
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var selectButton:UIButton!
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet var selectButtonHeightConstraint:NSLayoutConstraint!
    @IBOutlet var searchBar:UISearchBar!

    var contactList:[Staff] = []{
        didSet{
            self.filteredContactList = contactList
        }
    }
    
    var filteredContactList:[Staff] = []{
        didSet{
            self.tableView.reloadData()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    var selectedContactsForOrder: [String] = []
    var displayType: ContactDisplayType = .view
    var orderId:String = "0"
    var orderInfoDelegate:OrderInfoDataUpdateDelegate?
    var basicInfoModel: BasicInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.orderContactDelegate = self
        self.getAllContactList()
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getAllContactList),
                                               name: .reloadContactListVC, object: nil)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RestCloudService.shared.orderContactDelegate = self
        self.showNavigationBar()
        self.appNavigationBarStyle()
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .white
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        titleLabel.text = LocalizationManager.shared.localizedString(key: "contactListTitle")
        titleLabel.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
      
        addContactButton.tag = 0
        selectButton.tag = 1
        [addContactButton, selectButton].forEach { (theButton) in
            theButton?.layer.cornerRadius = theButton!.frame.height / 2.0
            theButton?.layer.borderWidth = 1
            theButton?.layer.borderColor = UIColor.primaryColor().cgColor
            theButton?.setTitle(title, for: .normal)
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
       
            if theButton == addContactButton{
                theButton?.setTitle(LocalizationManager.shared.localizedString(key: "addContactText"), for: UIControl.State.normal)
                theButton?.backgroundColor = .white
                theButton?.setTitleColor(.primaryColor(), for: .normal)
                theButton?.addTarget(self, action: #selector(self.addContactButtonTapped(_:)), for: .touchUpInside)
            }else if theButton == selectButton{
                theButton?.setTitle(LocalizationManager.shared.localizedString(key: "selectButtonText"), for: UIControl.State.normal)
                theButton?.backgroundColor = .primaryColor()
                theButton?.setTitleColor(.white, for: .normal)
                theButton?.addTarget(self, action: #selector(self.selectButtonTapped(_:)), for: .touchUpInside)
            }
        }
        selectButton.isHidden = self.displayType == .view ? true : false
        addContactButton.isHidden = self.displayType == .view ? true : false
        selectButtonHeightConstraint.constant = self.displayType == .view ? 0.0 : 50.0
        
        searchBar.placeholder = LocalizationManager.shared.localizedString(key: "searchBarPlaceHolderText")
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }

    @objc func getAllContactList() {
        self.showHud()
        RestCloudService.shared.orderContactDelegate = self
        let params:[String:Any] = ["order_id": self.orderId,
                                   "company_id": RMConfiguration.shared.companyId,
                                   "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.getOrderStaffs(params: params)
    }

    func assignContactList(data: [Staff]?) {
        if self.displayType == .view && self.selectedContactsForOrder.count > 0 {
            let selectedData = data?.filter({(self.selectedContactsForOrder.contains($0.id ?? ""))})
            self.contactList = selectedData ?? []
        }else{
            self.contactList = data ?? []
        }
        let adminContact = data?.filter{$0.role == "1"}
        if adminContact?.count ?? 0>0{
            self.selectedContactsForOrder.append(adminContact?[0].id ?? "")
        }
    }
    
    @objc func selectButtonTapped(_ sender: UIButton) {
        if self.selectedContactsForOrder.count == 0 {
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "selectContactMessage"), target: self)
            return
        }
        
        var contactsData:[Any] = []
        var postData:[String:Any] = [:]
        
        for id in self.selectedContactsForOrder{
            var staff:[String:Any] = [:]
            staff["staff_id"] = id
            contactsData.append(staff)
        }
        postData["contacts"] = contactsData
        postData["order_id"] = self.orderId
        postData["company_id"] = RMConfiguration.shared.companyId
        postData["workspace_id"] = RMConfiguration.shared.workspaceId
        print(postData)
        
        self.showHud()
        RestCloudService.shared.orderContactDelegate = self
        RestCloudService.shared.addContacts(params: postData)
    }
    
    @objc func addContactButtonTapped(_ sender: UIButton){
        
        DispatchQueue.main.async {
            if let vc = UIViewController.from(storyBoard: .userManagement, withIdentifier: .addNewContact) as? AddNewContactVC {
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.basicInfoModel = self.basicInfoModel
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tickMarkButtonTapped(_ sender: UIButton){
        
        if let index = self.selectedContactsForOrder.firstIndex(of: "\(sender.tag)"){
            self.selectedContactsForOrder.remove(at: index)
        }else{
            self.selectedContactsForOrder.append("\(sender.tag)")
        }
        self.tableView.reloadData()
    }
}

extension ContactListVC : UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(filteredContactList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactListTableViewCell
        cell.setContent(data: self.filteredContactList[indexPath.row], displayType: self.displayType, isSelectedRow: self.selectedContactsForOrder.contains(self.filteredContactList[indexPath.row].id ?? "0"))
        cell.tickMarkButton.addTarget(self, action: #selector(self.tickMarkButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        if (self.searchBar.text ?? "").isEmptyOrWhitespace(){
            self.filteredContactList = self.contactList
        }else{
            self.filteredContactList = self.contactList.filter({ (contact) -> Bool in
                return contact.first_name?.lowercased().contains((self.searchBar.text ?? "").lowercased()) ?? false
            })
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text?.count ?? 0<3 {
            if (self.searchBar.text ?? "").isEmptyOrWhitespace(){
                self.filteredContactList = self.contactList
            }else{
                self.filteredContactList = self.contactList.filter({ (contact) -> Bool in
                   
                    return contact.first_name?.lowercased().contains((self.searchBar.text ?? "").lowercased()) ?? false
                })
            }
        }
    }
}

extension ContactListVC: RCOrderContactDelegate {
   
    /// OrderStaffs delegate
    func didReceiveOrderStaffs(data: [Staff]?) {
        self.hideHud()
        self.assignContactList(data: data)
    }
   
    func didFailedToReceiveOrderStaffs(errorMessage: String) {
        self.hideHud()
    }
    
    /// Add contacts to order  delegate
    func didReceiveAddContacts(message: String){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.orderInfoDelegate?.updateOrderInfoData(.contact, orderInfoData: nil)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func didFailedToReceiveAddContacts(errorMessage: String){
        self.hideHud()
    }

 }
