//
//  OnGoingListVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class OnGoingListVC: UIViewController {

    @IBOutlet var contentView:UIView!
    @IBOutlet var tableView:UITableView!

    var onGoingList:[DMSGetOrderListData] = []
    var orderType, filterType : String?
    var target: HomeVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getOrderList()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.appNavigationBarStyle()
        self.showCustomBackBarItem()
        self.title = LocalizationManager.shared.localizedString(key: "onGoingListHeaderText")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupUI(){
        self.tableView.allowsSelection = true
        self.tableView.separatorStyle = .none
     
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.contentView.roundCorners(corners: .allCorners, radius: 10.0)
        self.contentView.layer.shadowOpacity = 0.4
        self.contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.contentView.layer.shadowRadius = 5.0
        self.contentView.layer.shadowColor = UIColor.customBlackColor().cgColor
        self.contentView.layer.masksToBounds = false
    }
   
    override func filterNavigationItemTapped(_ sender: UIBarButtonItem) {
        if let vc = UIViewController.from(storyBoard: .home, withIdentifier: .onGoingFilter) as? OngoingListFilterVC{
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
 
    @objc func getOrderList(){
        self.orderType = self.appDelegate().defaults.value(forKey:Config.Text.filterOrder) as? String
        self.filterType = self.appDelegate().defaults.value(forKey:Config.Text.filterType) as? String
        
        let params:[String:String] = ["order_by":"\(filterType ?? "")",
                                      "order_type":"\(orderType ?? "")"]
        print(params)
    }

}

extension OnGoingListVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow( self.onGoingList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OnGoingListTableViewCell
        cell.setContent(data: self.onGoingList[indexPath.row], target: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.pushToOrderInfo(id: self.onGoingList[indexPath.row].id ?? "")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
