//
//  SpecFileListVC.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 28/06/22.
//

import UIKit

class TaskFileListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var okButton: UIButton!
  
    var specModel: [TaskFilesData] = []
    var target: UIViewController? = nil
    var pageType: TaskInputDisplayType = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.appNavigationBarStyle()
        self.showCustomBackBarItem()
        RestCloudService.shared.taskDelegate = self
        
        self.title = "Spec File List"
    }
    
    func setupUI() {
     
        self.okButton.addTarget(self, action: #selector(okButtonTapped(_:)), for: .touchUpInside)
        
        self.okButton.setTitle("", for: .normal)
        self.okButton.layer.cornerRadius = self.okButton.frame.height / 2.0
        self.okButton.setImage(UIImage.init(named: "ic_ok")?.redraw(size: CGSize.init(width: 30.0, height: 30.0), tintColor: .white), for: .normal)
        self.okButton.tintColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
  
    func deleteTaskFile(data: TaskFilesData){
        
        UIAlertController.showAlertWithCompletionHandler(title: LocalizationManager.shared.localizedString(key: "sure_to_delete_task_file_msg"),
                                                         message: data.orginalfilename,
                                                         firstButtonTitle: LocalizationManager.shared.localizedString(key: "noButtonText"),
                                                         secondButtonTitle: LocalizationManager.shared.localizedString(key: "yesButtonText"),
                                                         firstButtonStyle: .cancel, secondButtonStyle: .destructive, target: self)
        { index in
            if index == 1{
                self.showHud()
                let params:[String: Any] = [ "fileId": data.id,
                                             "user_id": RMConfiguration.shared.userId,
                                             "staff_id": RMConfiguration.shared.staffId,
                                             "company_id": RMConfiguration.shared.companyId,
                                             "workspace_id": RMConfiguration.shared.workspaceId,
                                             "order_id": RMConfiguration.shared.orderId]
                print(params)
                RestCloudService.shared.deleteTaskFiles(params: params)
            }
        }
    }
    
    func removeSpecFileLocally(index: Int){
        self.specModel.remove(at: index)
        self.tableView.reloadData()
    }

    func urlSession(location: URL, fileName: String) {
        debugPrint("Download finished: \(location)")
        do {
            let downloadedData = try Data(contentsOf: location)

            DispatchQueue.main.async(execute: {
                print("transfer completion OK!")

                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                let destinationPath = documentDirectoryPath.appendingPathComponent(fileName)

                let pdfFileURL = URL(fileURLWithPath: destinationPath)
                FileManager.default.createFile(atPath: pdfFileURL.path,
                                               contents: downloadedData,
                                               attributes: nil)

                if FileManager.default.fileExists(atPath: pdfFileURL.path) {
                    print("pdfFileURL present!") // Confirm that the file is here!
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reloadSpecFileInCreateStyleVC(){
        if let vc = self.target as? TaskInputVC{
            vc.taskFileReAssign(taskFiles: self.specModel)
        }
        self.navigationController?.popViewController(animated: true)
    }
  
    override func backNavigationItemTapped(_ sender: Any) {
        self.reloadSpecFileInCreateStyleVC()
    }
    
    @objc func okButtonTapped(_ sender: UIButton) {
        self.reloadSpecFileInCreateStyleVC()
    }
}

extension TaskFileListVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskFileDownloadTVCell
        if indexPath.row < self.specModel.count{
            cell.taskFilesList = self.specModel
            cell.pageType = self.pageType
            cell.setContent(index: indexPath.row, data: self.specModel[indexPath.row], target: self)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.specModel.count
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension TaskFileListVC: RCTaskDelegate{
    /// Delete files list delegates
    func didReceiveDeleteTaskFiles(message: String, fileId: String){
        self.hideHud()
        if let index = self.specModel.firstIndex(where: { $0.id == fileId }) {
            self.specModel.remove(at: index)
        }
    }
    
    func didFailedToReceiveDeleteTaskFiles(errorMessage: String){
        self.hideHud()
    }
}

//extension TaskFileListVC: PFSpecFileUploadDelegate {
//
//    func didReceiveSpecUploadedFile(specFile: [TaskSpecModel]){
//        self.specModel = specFile
//        self.tableView.reloadData()
//    }
//}
