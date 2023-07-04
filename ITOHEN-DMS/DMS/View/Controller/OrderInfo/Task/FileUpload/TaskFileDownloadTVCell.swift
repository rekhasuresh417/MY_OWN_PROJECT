//
//  TaskFileDownloadTVCell.swift
//  IDAS iOS
//
//  Created by Dharma sheelan on 19/11/21.
//

import UIKit

class TaskFileDownloadTVCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButtonBackGroundView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var seeMoreButtonHConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHConstraint: NSLayoutConstraint!
    
    var data: TaskFilesData? = nil
    var pageType: TaskInputDisplayType = .add
    var target: UIViewController? = nil
    var index: Int? = 0
    var taskFilesList: [TaskFilesData] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.titleLabel.textColor = .black
        self.titleLabel.font = .appFont(ofSize: 13.0, weight: .regular)
        self.titleLabel.textAlignment = .left
        self.titleLabel.text = "Rekha_image.png"
        
        self.sizeLabel.textColor = .gray
        self.sizeLabel.font = .appFont(ofSize: 11.0, weight: .regular)
        self.sizeLabel.textAlignment = .left
        self.sizeLabel.text = "240 KB"
        
        self.deleteButton.setTitle("", for: .normal)
        self.iconImageView.image = UIImage.init(named: "ic_file")
        
        self.downloadButton.setImage(UIImage.init(named: "ic_download")?.redraw(size: CGSize.init(width: 12.0, height: 12.0), tintColor: .white), for: .normal)
        self.downloadButton.setTitle("", for: .normal)
        self.downloadButton.addTarget(self, action: #selector(self.downloadButtonTapped(_:)), for: .touchUpInside)
      
        self.deleteButton.setImage(UIImage.init(named: "ic_file_delete")?.redraw(size: CGSize.init(width: 12.0, height: 12.0), tintColor: .white), for: .normal)
        self.deleteButton.setTitle("", for: .normal)
        self.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
     
        self.cancelButton.setTitle("", for: .normal)
        self.cancelButton.setImage(UIImage.init(named: "ic_cancel")?.redraw(size: CGSize.init(width: 25.0, height: 25.0), tintColor: UIColor.gray), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setContent(index: Int, data: TaskFilesData, target: UIViewController? = nil){

        self.data = data
        self.target = target
      
        if self.target is TaskInputVC{
            self.seeMoreButton.setTitle("View all", for: .normal)
            self.seeMoreButtonHConstraint.constant = 0
            self.seeMoreButton.addTarget(self, action: #selector(self.viewAllButtonTapped(_:)), for: .touchUpInside)
            
            self.seeMoreButton.isHidden = taskFilesList.count > 3 && index == 2 ? false : true
            self.seeMoreButtonHConstraint.constant = taskFilesList.count > 3 && index == 2 ? 20 : 0
        }
        
        self.sizeLabel.text = "\(String().convertByteToString(byte: Int64(self.data?.filesize ?? "") ?? 0))"
        
        let fileArr = self.data?.orginalfilename.components(separatedBy: ".")
        self.titleLabel.text = fileArr?[0] ?? ""
        let fileName: String = fileArr?[1] ?? ""
        
        if Config.AppConstants.IMAGES_TYPES.contains(fileName){
            self.iconImageView.image = UIImage.init(named: "ic_image")
        }else{
            self.iconImageView.image = UIImage.init(named: "ic_file")
        }
   
        if "\(data.id)".isEmptyOrWhitespace() || "\(data.id)".contains("-"){
            self.cancelButtonBackGroundView.isHidden = false
        }else{
            self.cancelButtonBackGroundView.isHidden = true
        }
    
        self.deleteButton.isEnabled = self.pageType != .view ? true : false
        self.downloadButton.isEnabled = self.pageType != .view ? true : false
        
        self.deleteButton.alpha = self.pageType != .view ? 1.0 : 0.5
        self.downloadButton.alpha = self.pageType != .view ? 1.0 : 0.5
    }
    
    @objc func downloadButtonTapped(_ sender: UIButton) {
        if let taskFileModel = self.data{
            if let vc = self.target as? TaskInputVC{
                vc.downloadTaskFile(taskFile: taskFileModel,
                                    sourceView: self.target?.view,
                                    target: self.target)
            }else if let vc = self.target as? TaskFileListVC{
                vc.downloadTaskFile(taskFile: taskFileModel,
                                    sourceView: self.target?.view,
                                    target: self.target)
            }
        }
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        if let fileData = self.data{
            if let vc = self.target as? TaskInputVC{
                vc.deleteTaskFile(data: fileData)
            }else if let vc = self.target as? TaskFileListVC{
                vc.deleteTaskFile(data: fileData)
            }
        }
    }
   
    @objc func cancelButtonTapped(_ sender: UIButton) {
        if let vc = self.target as? TaskInputVC {
            vc.removeSpecFileLocally(filesData: self.data, index: index ?? 0)
        }else if let vc = self.target as? TaskFileListVC {
            vc.removeSpecFileLocally(index: index ?? 0)
        }
    }
 
    @objc func viewAllButtonTapped(_ sender: UIButton) {
        if let vc = self.target as? TaskInputVC{
            vc.pushToTaskFileListVC()
        }
    }
}
