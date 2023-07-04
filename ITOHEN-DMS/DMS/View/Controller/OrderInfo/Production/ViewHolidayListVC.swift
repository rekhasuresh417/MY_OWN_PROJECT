//
//  ViewHolidayListVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 17/09/21.
//

import UIKit

class ViewHolidayListVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var tableViewHConstraint: NSLayoutConstraint!
 
    var selctedOrder: Int = 0
    var getHolidayList:[String] = []
    var getCompnesateWorkingList:[String] = []
    
    var addedHolidayList: [String] = []
    var addedCompensateList: [String] = []
    var dataSource: [String] = []{
        didSet{
            self.tableview.reloadData()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    

    func setupUI() {
    
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.topView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.topView.addGestureRecognizer(tap)
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
    
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.separatorStyle = .none
        self.dataSource = self.getHolidayList

        if CGFloat(self.dataSource.count * 60) + CGFloat(self.getCompnesateWorkingList.count * 60) > self.view.bounds.height-200{
            self.tableViewHConstraint.constant = self.view.bounds.height - 200
        }else{
            self.tableViewHConstraint.constant = CGFloat(self.dataSource.count * 60) + CGFloat(self.getCompnesateWorkingList.count * 60) + 50
        }

        self.cancelButton.backgroundColor = .primaryColor()
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "closeButtonText"), for: .normal)
        self.cancelButton.setTitleColor(.white, for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.cancelButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)

    }
 
    @objc func applyButtonTapped(_ sender: UIButton) {
       print(addedHolidayList)
    }
    
    @objc func dismissViewController(shouldReload:Bool = false) {
        self.dismiss(animated: true, completion: {
            if shouldReload{
              //  NotificationCenter.default.post(name: .reloadProgressDetailVC, object: nil)
            }
        })
    }
}

extension ViewHolidayListVC : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.getCompnesateWorkingList.count > 0 && self.dataSource.count > 0{
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.getCompnesateWorkingList.count > 0 && self.dataSource.count > 0{
            if section == 0{
                return self.getCompnesateWorkingList.count
            }
            return self.dataSource.count
        }else if self.getCompnesateWorkingList.count > 0{
            return self.getCompnesateWorkingList.count
        }else{
            return self.dataSource.count
        }
    
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.getCompnesateWorkingList.count > 0 && self.dataSource.count > 0{
            if section == 0{
                return "Compensate Working Days"
            }
            return "Holidays List"
        }else if self.getCompnesateWorkingList.count > 0{
            return "Compensate Working Days"
        }else{
            return "Holidays List"
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewHolidayListTableviewCell
        cell.titleLabel.textColor = .customBlackColor()
        cell.titleLabel.highlightedTextColor = .primaryColor()
    
        if self.getCompnesateWorkingList.count > 0 && self.dataSource.count > 0{
            if indexPath.section == 0 {
                cell.titleLabel.text = self.getCompnesateWorkingList[indexPath.row]
                cell.dayButton .setTitle("  \(self.getFormattedDate(strDate: self.getCompnesateWorkingList[indexPath.row], currentFomat: "dd-MM-yyyy", expectedFromat: "EEEE"))  ", for: .normal)
            }else{
                cell.titleLabel.text = self.dataSource[indexPath.row]
                cell.dayButton .setTitle("  \(self.getFormattedDate(strDate: self.dataSource[indexPath.row], currentFomat: "dd-MM-yyyy", expectedFromat: "EEEE"))  ", for: .normal)
            }
        }else  if self.getCompnesateWorkingList.count > 0{
            cell.titleLabel.text = self.getCompnesateWorkingList[indexPath.row]
            cell.dayButton .setTitle("  \(self.getFormattedDate(strDate: self.getCompnesateWorkingList[indexPath.row], currentFomat: "dd-MM-yyyy", expectedFromat: "EEEE"))  ", for: .normal)
        }else{
            cell.titleLabel.text = self.dataSource[indexPath.row]
            cell.dayButton .setTitle("  \(self.getFormattedDate(strDate: self.dataSource[indexPath.row], currentFomat: "dd-MM-yyyy", expectedFromat: "EEEE"))  ", for: .normal)
        }
      
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       if let headerView = view as? UITableViewHeaderFooterView {
        headerView.textLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        headerView.textLabel?.textColor = .customBlackColor()
       }
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

}

class ViewHolidayListTableviewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dayButton: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        self.contentView.roundCorners(corners: .allCorners, radius: 10.0)
        
        self.titleLabel.font = UIFont.appFont(ofSize: 13.0, weight: .semibold)
        self.titleLabel.textColor = .customBlackColor()
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 2
 
        self.dayButton.backgroundColor = .white
        self.dayButton.layer.borderWidth = 1.0
        self.dayButton.layer.borderColor = UIColor.gray.cgColor
        self.dayButton.layer.cornerRadius = self.dayButton.frame.height / 2.0
        self.dayButton.setTitleColor(.gray, for: .normal)
        self.dayButton.titleLabel?.font = UIFont.appFont(ofSize: 13.0, weight: .medium)
    }

}


