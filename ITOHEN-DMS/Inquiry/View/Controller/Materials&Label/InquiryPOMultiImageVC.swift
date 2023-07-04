//
//  InquiryPOMultiImageVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 27/04/23.
//

import UIKit

class InquiryPOMultiImageVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var images: [String]? = []
    var screenTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = screenTitle
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
    }
    
    func setupUI(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .singleLine
    }
}

extension InquiryPOMultiImageVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.updateNumberOfRow(self.images?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InquiryPOMultiImageTableViewCell
            if let data = self.images?[indexPath.row]{
                cell.setContent(data: data, target: self)
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}
