//
//  NotificationVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var tableView:UITableView!
 
    var dataSource:[DMSNotificationData] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.dashboardDelegate = self
        self.getNotificationsList()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.showCustomBackBarItem()
        self.title = LocalizationManager.shared.localizedString(key: "notificationTitle")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupUI(){
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    @objc func getNotificationsList(){
        self.showHud()
        let params:[String:Any] = [ "company_id": RMConfiguration.shared.companyId,
                                   "workspace_id": RMConfiguration.shared.workspaceId,
                                   "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId ]
        print(params)
        RestCloudService.shared.getNotificationList(params: params)
  
    }
 
    private func pushToWorkspace(id:String){
        self.navigationController?.popViewController(animated: true)
    }
 
}

extension NotificationVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.dataSource.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTVCell
        cell.setContent(data: self.dataSource[indexPath.row], target: self)
        return cell
    }
  
}

extension NotificationVC: RCDashboardDelegate {
  
    // Get notification list delegate
    func didReceiveNotificationList(data: [DMSNotificationData]) {
        self.hideHud()
        self.dataSource = data
    }
    
    func didFailedToReceiveNotificationList(errorMessage: String) {
        self.hideHud()
    }

}
