//
//  ReOrderTasks.swift
//  Itohen-dms
//
//  Created by Dharma sheelan on 27/03/21.
//

import UIKit

class ReOrderTasks: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var tableView:UITableView!
    @IBOutlet var titleLabel:UILabel!
    
    var sections: [EditTaskTemplateData] = []
    var tasks: [TaskTemplateStructureDatum] = []
    var categoryIndex: Int = 0
    var type:ReOrderType?
    var target:TaskInputVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
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
        titleLabel.text =  LocalizationManager.shared.localizedString(key: self.type == .category ? "reOrderTasksCategoryTitle" : "reOrderTasksTaskTitle")
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.setEditing(true, animated: false)
        
        self.saveButton.backgroundColor = .primaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.saveButton.addTarget(self, action: #selector(self.saveButtonButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func saveButtonButtonTapped(_ sender: UIButton) {
        
        if self.type == .category{
            for i in 0..<self.sections.count {
             //   self.sections[i].categorySeq = "\(i + 1)"
            }
            self.target?.dataSections = self.sections
            self.dismiss(animated: true) {
                self.target?.tableView.reloadData()
            }
        }else if self.type == .task{
            for i in 0..<self.tasks.count {
                self.tasks[i].taskSeq = "\(i + 1)"
            }
           // self.target?.sections[categoryIndex].data = self.tasks
            self.dismiss(animated: true) {
                self.target?.tableView.reloadData()
            }
        }
    }
    
    @objc func dismissViewController(){
        self.dismiss(animated: true, completion:nil)
    }
}

extension ReOrderTasks : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == .category{
            return self.sections.count
        }else if self.type == .task{
            return self.tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReOrderListTVCell
        if self.type == .category{
            cell.setContent(data: self.sections[indexPath.row])
        }else if self.type == .task{
            cell.setContent(data: self.tasks[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if self.type == .category{
            let selectedItem = self.sections[sourceIndexPath.row]
            self.sections.remove(at: sourceIndexPath.row)
            self.sections.insert(selectedItem, at: destinationIndexPath.row)
        }else if self.type == .task{
            let selectedItem = self.tasks[sourceIndexPath.row]
            self.tasks.remove(at: sourceIndexPath.row)
            self.tasks.insert(selectedItem, at: destinationIndexPath.row)
        }
    }
}

enum ReOrderType {
    case category
    case task
}
