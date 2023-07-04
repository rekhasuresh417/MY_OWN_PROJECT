//
//  TaskRescheduleHistoryVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class TaskRescheduleHistoryVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var allButton: UIButton!
    @IBOutlet var startDateButton: UIButton!
    @IBOutlet var endDateButton: UIButton!
    @IBOutlet var picButton: UIButton!
    @IBOutlet var taskNameLabel: UILabel!
    
    var sectionButtons:[UIButton] = []
    var orderId:String = "0"
    var taskId:String = "0"
    var catName:String = ""
    
    var dataSource:[DMSGetRescheduleHistoryData] = []{
        didSet{
            self.tableView.reloadData()
        }
    }

    var tempDataSource:[DMSGetRescheduleHistoryData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        RestCloudService.shared.taskUpdateDelegate = self
        self.getRescheduleHistory()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "historyButtonText")
    }
 
    func setupUI() {
        //self.view.backgroundColor = .clear
     
        self.sectionButtons = [allButton, startDateButton, endDateButton, picButton]
        self.allButton.tag = 1
        self.startDateButton.tag = 2
        self.endDateButton.tag = 3
        self.picButton.tag = 4
        self.sectionButtons.forEach { (button) in
            button.titleLabel?.font = .appFont(ofSize: 15.0, weight: .medium)
            button.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
            button.isEnabled = true
            button.setTitleColor(.gray, for: .normal)
            
            if button == allButton{
                button.setTitleColor(.primaryColor(), for: .normal)
                button.setTitle(LocalizationManager.shared.localizedString(key: "allButtonText"), for: .normal)
            }else if button == startDateButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "startDateText"), for: .normal)
            }else if button == endDateButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "endDateText"), for: .normal)
            }else if button == picButton{
                button.setTitle(LocalizationManager.shared.localizedString(key: "picTitle"), for: .normal)
            }
        }
        
        self.taskNameLabel.text = catName
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
   
    @objc func sectionButtonTapped(_ sender: UIButton) {
        self.sectionButtons.forEach { (button) in
            button.backgroundColor = .white
            button.setTitleColor((button.tag == sender.tag) ? .primaryColor() : .darkGray, for: .normal)
       }
        
        switch sender.tag{
        case 1:
            self.dataSource = self.tempDataSource
        case 2:
            self.dataSource = self.tempDataSource.filter({$0.rescheduledStartDate?.isEmptyOrWhitespace() == false})
        case 3:
            self.dataSource = self.tempDataSource.filter({$0.rescheduledEndDate?.isEmptyOrWhitespace() == false})
        case 4:
            self.dataSource = self.tempDataSource.filter({$0.rescheduledType == Config.Text.reassign})
        default:
            return
        }
    }
    
    func getRescheduleHistory() {
        self.showHud()
        let params:[String: Any] = [ "order_id": self.orderId,
                                    "task_id": self.taskId,
                                    "user_id": RMConfiguration.shared.userId,
                                    "staff_id": RMConfiguration.shared.staffId,
                                    "company_id": RMConfiguration.shared.companyId,
                                    "workspace_id": RMConfiguration.shared.workspaceId ]
        print(params)
        RestCloudService.shared.reScheduleHistory(params: params)
    }
   
}

extension TaskRescheduleHistoryVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow( self.dataSource.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RescheduleHistoryTableViewCell
        cell.setContent(data: self.dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
}

extension TaskRescheduleHistoryVC: RCTaskUpdateDelegate{

    /// Reschedule  history
    func didReceiveRescheduleHistory(data: [DMSGetRescheduleHistoryData]?){
        self.hideHud()
        if let historyData = data{
            self.dataSource = historyData
            self.tempDataSource = historyData

        }
    }
    
    func didFailedToReceiveRescheduleHistory(errorMessage: String){
        self.hideHud()
        self.dataSource = []
        self.tempDataSource = []
    }
   
}
