//
//  OngoingListFilterVC.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 03/04/21.
//

import UIKit

class OngoingListFilterVC: UIViewController {
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var applyButton:UIButton!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var switchControl: UISwitch!
    @IBOutlet var ascendingButton: UIButton!
    @IBOutlet var descendingButton: UIButton!
    
    @IBOutlet weak var tableViewHConstraint: NSLayoutConstraint!
    var orderType, filterType: String?
    var target:HomeVC?
    
    var dataSource:[String] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    var buyer, partner, selectedFilterType : String?
    var selectedIndex: IndexPath?
    var index : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.setupUI()
        self.hideNavigationBar()
    }
    
    func loadData() {
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            buyer = "Factory"
            partner = "PCU"
            selectedFilterType = "Factory"
        }else  if RMConfiguration.shared.workspaceType == Config.Text.factory{
            buyer = "Buyer"
            partner = "PCU"
            selectedFilterType = "Buyer"
        }else  if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            buyer = "Buyer"
            partner = "Factory"
            selectedFilterType = "Buyer"
        }
        dataSource = ["\(buyer!)",
                      "\(partner!)",
                      "\(LocalizationManager.shared.localizedString(key: "earliestUpcomingDeliveryDate"))",
                      "\(LocalizationManager.shared.localizedString(key: "mostDelayedDelivery"))"]
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.async {
            self.tableViewHConstraint.constant = CGFloat((self.dataSource.count) * 45)//Here 30 is my cell height
            self.tableView.reloadData()
        }
    }
    
    func setupUI(){
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.topView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.topView.addGestureRecognizer(tap)
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        sectionTitleLabel.textColor = .customBlackColor()
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "filterTitle")
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white
        
        self.orderType = self.appDelegate().defaults.value(forKey:Config.Text.filterOrder) as? String
        self.filterType = self.appDelegate().defaults.value(forKey:Config.Text.filterType) as? String
        
        self.ascendingButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.descendingButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        
        if self.orderType == "asc" {
            self.ascendingButton.isUserInteractionEnabled = true
            self.ascendingButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.descendingButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
            self.switchControl.setOn(false, animated: false)
        }else {
            self.descendingButton.isUserInteractionEnabled = true
            self.descendingButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.ascendingButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
            self.switchControl.setOn(true, animated: false)
        }
        
        self.switchControl.thumbTintColor = .primaryColor()
        
        if RMConfiguration.shared.workspaceType == Config.Text.buyer{
            if self.filterType == "factory_name" {
                index = 0
            }else if self.filterType == "pcu_name" {
                index = 1
            }else if self.filterType == "packing_end_date" {
                index = 2
            }else if self.filterType == "pending_tasks" {
                index = 3
            }
        }else  if RMConfiguration.shared.workspaceType == Config.Text.factory{
            if self.filterType == "buyer_name" {
                index = 0
            }else if self.filterType == "pcu_name" {
                index = 1
            }else if self.filterType == "packing_end_date" {
                index = 2
            }else if self.filterType == "pending_tasks" {
                index = 3
            }
        }else if RMConfiguration.shared.workspaceType == Config.Text.pcu{
            if self.filterType == "buyer_name" {
                index = 0
            }else if self.filterType == "factory_name" {
                index = 1
            }else if self.filterType == "packing_end_date" {
                index = 2
            }else if self.filterType == "pending_tasks" {
                index = 3
            }
        }
        selectedIndex = IndexPath(item: index, section: 0)
        self.loadData()
        
        self.applyButton.isUserInteractionEnabled = true
        self.applyButton.backgroundColor = .primaryColor()
        self.applyButton.layer.cornerRadius = self.applyButton.frame.height / 2.0
        self.applyButton.setTitle(LocalizationManager.shared.localizedString(key: "applyButtonText"), for: .normal)
        self.applyButton.setTitleColor(.white, for: .normal)
        self.applyButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.applyButton.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
       
        self.cancelButton.backgroundColor = .white
        self.cancelButton.layer.borderWidth = 1.0
        self.cancelButton.layer.borderColor = UIColor.primaryColor().cgColor
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        self.cancelButton.setTitleColor(.primaryColor(), for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .medium)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: .touchUpInside)
   
    }
    
    @IBAction func switchButtonTapped(_ sender: UISwitch){
        if (sender.isOn == true) {
            self.descendingButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.ascendingButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
        } else {
            self.ascendingButton.setTitleColor(.primaryColor(), for: UIControl.State.normal)
            self.descendingButton.setTitleColor(UIColor.customBlackColor(), for: UIControl.State.normal)
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton){
        
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false

        if self.switchControl.isOn {
            orderType = "desc"
        }else{
            orderType = "asc"
        }
        
        if (selectedFilterType?.contains("Factory"))!{
            filterType = "factory_name"
        }else if (selectedFilterType?.contains("PCU"))! {
            filterType = "pcu_name"
        }else if (selectedFilterType?.contains("Buyer"))! {
            filterType = "buyer_name"
        }else if selectedFilterType == "Earliest upcoming delivery date" {
            filterType = "packing_end_date"
        }else if selectedFilterType == "Most delayed delivery" {
            filterType = "pending_tasks"
        }
        self.appDelegate().defaults.set(orderType, forKey: Config.Text.filterOrder)
        self.appDelegate().defaults.set(filterType, forKey: Config.Text.filterType)
        
        let params:[String:String] = ["order_by":"\(filterType!)",
                                      "order_type":"\(orderType!)"]
        print(params)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton){
        self.dismissViewController()
    }
    
    @objc func dismissViewController(shouldReload:Bool = false){
        self.dismiss(animated: true, completion: {
            if shouldReload{
//                NotificationCenter.default.post(name: .reloadHomeVC, object: nil)
//                NotificationCenter.default.post(name: .reloadOngoingListVC, object: nil)
            }
        })
    }
}

extension OngoingListFilterVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OngoingListFilterTVCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OngoingListFilterTVCell

        cell.name!.text = self.dataSource[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if (selectedIndex == indexPath) {
            cell.radioButton.setImage( UIImage.init(named: "radio-on-button"), for: .normal)
        } else {
            cell.radioButton.setImage( UIImage.init(named: "radio-on-button-1"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedIndex = indexPath as IndexPath
        selectedFilterType = self.dataSource[indexPath.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
}

class OngoingListFilterTVCell: UITableViewCell {

    @IBOutlet var radioButton: UIButton!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        radioButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
