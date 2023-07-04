//
//  ConcernedMembersVC.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 25/01/21.
//

import UIKit

protocol TaskInputAddConcernedMembersDelegate {
    func updateConcernedMembersOf(_ categoryId:String, taskId:String, type:ConcernedMembersFor, data:[String], dataForInstance:[String], unselectedDataForInstance: [String])
}

class ConcernedMembersVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var titleLabel:UILabel!
    
    var contactList:[OrderContact] = []
    var selectedContacts:[String] = []
    var previouslySelectedContacts:[String] = []
    var selectedContactsForThisInstance:[String] = []
    var unSelectedContactsForThisInstance:[String] = []
    
    var categotyId:String = "0"
    var taskId:String = "0"
    var type:ConcernedMembersFor = .category
    
    var orderInfoDelegate:TaskInputAddConcernedMembersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.previouslySelectedContacts = self.selectedContacts
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "contactListTitle")
    }
    
    func setupUI() {
        
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.topView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.topView.addGestureRecognizer(tap)
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        titleLabel.textColor = .customBlackColor()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        titleLabel.text =  LocalizationManager.shared.localizedString(key: "concernedMembersTitle")
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.saveButton.backgroundColor = .primaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func saveButtonButtonTapped(_ sender: UIButton) {
        self.orderInfoDelegate?.updateConcernedMembersOf(self.categotyId,
                                                         taskId: self.taskId,
                                                         type: self.type,
                                                         data: self.selectedContacts,
                                                         dataForInstance: self.selectedContactsForThisInstance,
                                                         unselectedDataForInstance: self.unSelectedContactsForThisInstance)
        self.dismissViewController()
    }
    
    @objc func tickMarkButtonTapped(_ sender: UIButton) {
        if let index = self.selectedContacts.firstIndex(of: "\(sender.tag)"){
            self.selectedContacts.remove(at: index)
            if let index = self.selectedContactsForThisInstance.firstIndex(of: "\(sender.tag)"){
                self.selectedContactsForThisInstance.remove(at: index)
            }
            if self.previouslySelectedContacts.firstIndex(of: "\(sender.tag)") != nil{
                self.unSelectedContactsForThisInstance.append("\(sender.tag)")
            }
        }else{
            self.selectedContacts.append("\(sender.tag)")
            if self.previouslySelectedContacts.firstIndex(of: "\(sender.tag)") == nil{ // Make sure its already added, avoid readding
                self.selectedContactsForThisInstance.append("\(sender.tag)")
            }
            if let index = self.unSelectedContactsForThisInstance.firstIndex(of: "\(sender.tag)"){
                self.unSelectedContactsForThisInstance.remove(at: index)
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion:nil)
    }    
}

extension ConcernedMembersVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ConcernedMembersTableViewCell
        cell.setContent(data: self.contactList[indexPath.row],
                        isSelectedRow: self.selectedContacts.contains(self.contactList[indexPath.row].staffId ?? ""))
        cell.tickMarkButton.addTarget(self, action: #selector(self.tickMarkButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

enum ConcernedMembersFor {
    case category
    case task
}
