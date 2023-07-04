//
//  WorkspaceVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class WorkspaceVC: UIViewController {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var addNewWorkspaceButton: UIButton!
    
    var workspaceData:[DMSWorkspaceList] =  [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    var target:HomeVC?
    var tabBarVC:TabBarVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupUI(){
       
        self.titleLabel.text = LocalizationManager.shared.localizedString(key: "workspace")
    
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.workspaceData = self.appDelegate().workspaceDetails.workspaceList
    }

}

extension WorkspaceVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workspaceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WorkspaceTableViewCell
        if indexPath.row < self.workspaceData.count{
            cell.setContent(data: self.workspaceData[indexPath.row], row: indexPath.row, target: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        RMConfiguration.shared.userId = workspaceData[indexPath.row].userId ?? "0"
        RMConfiguration.shared.staffId = workspaceData[indexPath.row].staffId ?? "0"
        RMConfiguration.shared.dateFormat = String().convertDMSDateFormat(dateFormat: DateFormat(rawValue: workspaceData[indexPath.row].dateformat ?? "") ?? .D_SP_M_SP_Y)
              
        UserDefaults.standard.storeCodable(workspaceData[indexPath.row], key: "currentWorkspace")
        self.appDelegate().getWorkspaceList() // for assign into workspaceList
                
        self.presentingViewController?.dismiss(animated: true, completion: { [self] in
            if let hasPopover = self.popoverPresentationController{
                target?.popoverPresentationControllerDidDismissPopover(hasPopover)
                target?.styleData = []
                target?.orderNoTextField.text = ""
                target?.workspaceDidChangeNotification()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
