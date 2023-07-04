//
//  SKUAddNewColorOrSize.swift
//  Itohen-dms
//
//  Created by Dharma on 06/01/21.
//

import UIKit
import MaterialComponents

class SKUAddNewColorOrSize: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var firstTextField:MDCOutlinedTextField!
    @IBOutlet var addButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    
    weak var activeField: UITextField?
    var getAllColors: [DMSAllColorSize] = []
    var getAllSizes: [DMSAllColorSize] = []
    
    var model:AddNewColorOrSize?
    var postData:[String] = ["","",""]{
        didSet{
            self.updateAddButtonStatus()
        }
    }
    var skuDelegate:AddedSKUProtocolDelegate?
    var skuData: DMSAllColorSize?
    var isColor: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        RestCloudService.shared.skuDelegate = self
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(SKUAddNewColorOrSize.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SKUAddNewColorOrSize.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        sectionTitleLabel.textColor = .customBlackColor()
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        sectionTitleLabel.text = (model?.type == .color) ? LocalizationManager.shared.localizedString(key: "addNewColorSectionTitle") : LocalizationManager.shared.localizedString(key: "addNewSizeSectionTitle")
        
        firstTextField.tag = 0
     
        [firstTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            if model?.type == .color{
                self.setup(theTextField!, placeholderLabel: LocalizationManager.shared.localizedString(key: "addNewColorPlaceHolderText"))
            }else{
                self.setup(theTextField!, placeholderLabel: LocalizationManager.shared.localizedString(key: "addNewSizePlaceHolderText"))
            }
        }
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white

        self.addButton.isUserInteractionEnabled = false
        self.addButton.backgroundColor = .lightGray
        self.addButton.layer.cornerRadius = self.addButton.frame.height / 2.0
        self.addButton.setTitle(LocalizationManager.shared.localizedString(key: "addNewColorOrSizeButtonText"), for: .normal)
        self.addButton.setTitleColor(.white, for: .normal)
        self.addButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.addButton.addTarget(self, action: #selector(self.addButtonTapped(_:)), for: .touchUpInside)
    }
    
    func updateAddButtonStatus() {
        let filterData = self.postData.filter { (text) -> Bool in
            return !text.isEmptyOrWhitespace()
        }
        if filterData.count > 0{
            self.addButton.isUserInteractionEnabled = true
            self.addButton.backgroundColor = .primaryColor()
        }else{
            self.addButton.isUserInteractionEnabled = false
            self.addButton.backgroundColor = .lightGray
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
        let filterData = self.postData.filter { (text) -> Bool in
            return !text.isEmptyOrWhitespace()
        }
        
        let params:[String:Any] = [
            "name": filterData[0],
            "company_id": RMConfiguration.shared.companyId,
            "workspace_id": RMConfiguration.shared.workspaceId,
            "user_id": RMConfiguration.shared.userId,
            "staff_id": RMConfiguration.shared.staffId,
            "status": true
            
        ]
        print(params)
        self.showHud()
        if model?.type == .color {
            RestCloudService.shared.addColor(params: params)
            
        }else{
            RestCloudService.shared.addSize(params: params)
        }
    }
    
    @objc func dismissViewController(shouldReload:Bool = false) {
        self.dismiss(animated: true, completion: {
            if shouldReload{
                if let data = self.skuData{
                    self.skuDelegate?.GetAddedSKU(isColor: self.isColor, data: data)
                }
                //NotificationCenter.default.post(name: .reloadSKUAddVC, object: nil)
            }
        })
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion:nil)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 20.0 // Padding between the bottom of the view and the top of the keyboard
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        guard let activeField = activeField, let keyboardHeight = keyboardSize?.height else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + verticalPadding, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        let activeRect = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: true)
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SKUAddNewColorOrSize: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let currentText = activeField?.text ?? ""
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if model?.type == .color {
            
            let addedColor = self.getAllColors.filter({
                currentText == ($0.title
                                  .lowercased()
                                  .trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
            })
            
            if addedColor.count>0 {
                UIAlertController.showAlert(message: "\(currentText) \(LocalizationManager.shared.localizedString(key: "alreadyExists"))",
                                            target: self)
                activeField?.resignFirstResponder()
                return
            }
            
        }else if model?.type == .size{
            let addedSize = self.getAllSizes.filter({$0.title.contains(currentText
                                                                        .lowercased()
                                                                        .trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
            })
            
            if addedSize.count>0 {
                UIAlertController.showAlert(message: "\(currentText) \(LocalizationManager.shared.localizedString(key: "alreadyExists"))",
                                            target: self)
                activeField?.resignFirstResponder()
                return
            }
        }
        activeField = nil
        self.postData[textField.tag] = textField.text ?? ""
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if model?.type == .color{
            return count <= 20
        }else if model?.type == .size{
            return count <= 10
        }
        return true
    }
}

extension SKUAddNewColorOrSize: RCSKUDelegate {
    
    func didReceiveAddColorResponse(message: String, data: DMSAllColorSize?){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.skuData = data
                self.isColor = true
                self.dismissViewController(shouldReload: true)
            }
        })
    }
    
    func didFailedToReceiveAddColor(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
    
    /// Add size delegates
    func didReceiveAddSizeResponse(message: String, data: DMSAllColorSize?){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: message, target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.skuData = data
                self.isColor = false
                self.dismissViewController(shouldReload: true)
            }
        })
    }
    
    func didFailedToReceiveAddSize(errorMessage: String){
        self.hideHud()
        UIAlertController.showAlert(message: errorMessage, target: self)
    }
}

struct AddNewColorOrSize {
    var type: AddNewTypes
}

enum AddNewTypes {
    case color
    case size
}
