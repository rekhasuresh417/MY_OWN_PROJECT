//
//  PopUpView.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 29/10/21.
//

import UIKit
import MaterialComponents

class PopUpView: UIViewController {
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var orderDeleteBackgroundView: UIView!
    @IBOutlet var orderDeleteView: UIView!
    @IBOutlet var orderDeleteRequestView: UIView!
    @IBOutlet var deleteTitleLabel: UILabel!
    @IBOutlet var deleteRequestTitleLabel: UILabel!
    @IBOutlet var deleteFirstMessageLabel: UILabel!
    @IBOutlet var deleteSecondMessageLabel: UILabel!
    @IBOutlet var deleteRequestMessageLabel: UILabel!
    
    @IBOutlet var reasonTextView: MDCOutlinedTextArea!{
        didSet { reasonTextView?.textView.addDoneCancelToolbar() }
    }
    @IBOutlet var deleteCancelButton: UIButton!
    @IBOutlet var deleteOkButton: UIButton!
    @IBOutlet var deleteRequestCancelButton: UIButton!
    @IBOutlet var deleteRequestOkButton: UIButton!

    var orderId:String = "0"
    
    weak var activeView: UIView?
    var orderStatusType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
      
        self.setNeedsStatusBarAppearanceUpdate()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.scrollView.backgroundColor = .clear
        
        self.reasonTextView.textView.delegate = self
        
        self.orderDeleteBackgroundView.backgroundColor = .clear
        self.orderDeleteView.roundCorners(corners: .allCorners, radius: 10.0)
        self.orderDeleteRequestView.roundCorners(corners: .allCorners, radius: 10.0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tapGesture.delegate = self
        self.orderDeleteBackgroundView.addGestureRecognizer(tapGesture)
        
        if  RMConfiguration.shared.roleId == Config.UserRole.admin {
            self.orderDeleteRequestView.isHidden = true
            self.orderDeleteView.isHidden = false
        }else {
            self.orderDeleteRequestView.isHidden = false
            self.orderDeleteView.isHidden = true
        }
        
        [deleteTitleLabel, deleteRequestTitleLabel, deleteFirstMessageLabel, deleteSecondMessageLabel, deleteRequestMessageLabel].forEach { (theLabel) in
            theLabel?.textAlignment = .left
            theLabel?.textColor = .gray
            theLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theLabel?.numberOfLines = 0
            
            if theLabel == deleteTitleLabel || theLabel == deleteRequestTitleLabel{
                theLabel?.textColor = .customBlackColor()
                theLabel?.font = UIFont.appFont(ofSize: 17.0, weight: .medium)
            }
        }
       
        [deleteOkButton, deleteRequestOkButton].forEach { (theButton) in
            theButton?.backgroundColor = .delayedColor(withAlpha: 0.3)
            theButton?.layer.cornerRadius = self.deleteOkButton.frame.height / 2.0
            theButton?.setTitle(LocalizationManager.shared.localizedString(key: "deleteButtonText"), for: .normal)
            theButton?.setTitleColor(.red, for: .normal)
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        }
       
        deleteOkButton.addTarget(self, action: #selector(self.deleteOrderButtonTapped(_:)), for: .touchUpInside)
        deleteRequestOkButton.addTarget(self, action: #selector(self.deleteRequestOrderButtonTapped(_:)), for: .touchUpInside)
        
        [deleteCancelButton, deleteRequestCancelButton].forEach { (theButton) in
            theButton?.backgroundColor = .primaryColor(withAlpha: 0.3)
            theButton?.layer.cornerRadius = self.deleteCancelButton.frame.height / 2.0
            theButton?.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
            theButton?.setTitleColor(.primaryColor(), for: .normal)
            theButton?.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theButton?.addTarget(self, action: #selector(self.deleteOrderCancelButtonTapped(_:)), for: .touchUpInside)
        }
        
        self.deleteAndCloseOrderText()
    }

    
    func deleteAndCloseOrderText() {
        if self.orderStatusType == "delete"{
            self.deleteTitleLabel.text = LocalizationManager.shared.localizedString(key: "deleteTitleText")
            self.deleteRequestTitleLabel.text = LocalizationManager.shared.localizedString(key: "deleteRequestTitleText")
            self.deleteFirstMessageLabel.text = LocalizationManager.shared.localizedString(key: "deleteOrderMessageText")
            self.deleteRequestMessageLabel.text = LocalizationManager.shared.localizedString(key: "deleteRequestOrderMessageText")
            self.deleteSecondMessageLabel.text = LocalizationManager.shared.localizedString(key: "undoneMessageText")
            [deleteOkButton, deleteRequestOkButton].forEach { (theButton) in
                theButton?.backgroundColor = .delayedColor(withAlpha: 0.3)
                theButton?.setTitleColor(.red, for: .normal)
                theButton?.setTitle(LocalizationManager.shared.localizedString(key: "deleteButtonText"), for: .normal)
            }
            self.setupMDCTextArea(self.reasonTextView, placeholderLabel: "Reason")

        }else if self.orderStatusType == "complete"{
            self.deleteTitleLabel.text = LocalizationManager.shared.localizedString(key: "closeTitleText")
            self.deleteRequestTitleLabel.text = LocalizationManager.shared.localizedString(key: "closeOrderRequestTitleText")
            self.deleteFirstMessageLabel.text = LocalizationManager.shared.localizedString(key: "closeOrderMessageText")
            self.deleteRequestMessageLabel.text = LocalizationManager.shared.localizedString(key: "closeRequestOrderMessageText")
            self.deleteSecondMessageLabel.text = LocalizationManager.shared.localizedString(key: "undoneMessageText")
            [deleteOkButton, deleteRequestOkButton].forEach { (theButton) in
                theButton?.backgroundColor = .primaryColor()
                theButton?.setTitleColor(.white, for: .normal)
                if self.appDelegate().userDetails.userRole == .admin{
                    theButton?.setTitle(LocalizationManager.shared.localizedString(key: "completedTitleText"), for: .normal)
                }else{
                    theButton?.setTitle(LocalizationManager.shared.localizedString(key: "submitButtonText"), for: .normal)
                }
            }
            self.setupMDCTextArea(self.reasonTextView, placeholderLabel: "Comments")
        }else{
            self.deleteTitleLabel.text = LocalizationManager.shared.localizedString(key: "cancelTitleText")
            self.deleteRequestTitleLabel.text = LocalizationManager.shared.localizedString(key: "cancelRequestTitleText")
            self.deleteFirstMessageLabel.text = LocalizationManager.shared.localizedString(key: "cancelOrderMessageText")
            self.deleteRequestMessageLabel.text = LocalizationManager.shared.localizedString(key: "cancelRequestOrderMessageText")
            self.deleteSecondMessageLabel.text = LocalizationManager.shared.localizedString(key: "undoneMessageText")
            [deleteOkButton, deleteRequestOkButton].forEach { (theButton) in
                theButton?.backgroundColor = .delayedColor(withAlpha: 0.3)
                theButton?.setTitleColor(.red, for: .normal)
                theButton?.setTitle(LocalizationManager.shared.localizedString(key: "submitButtonText"), for: .normal)
            }
            self.setupMDCTextArea(self.reasonTextView, placeholderLabel: "Reason")
        }
    }
 
    func deleteOrder() {
        
        self.view.isUserInteractionEnabled = false
        
     /*   let path:String = Config.API.apiAcceptOrderStatusUpdateRequest
        let postData: [String:Any] = ["order_id": "\(self.orderId)",
                                      "action": orderStatusType]
        
        let resource = Resource<DMSOrderDelete,
                                DMSError>(jsonDecoder: JSONDecoder(),
                                          path: path,
                                          method: .post,
                                          params: postData,
                                          headers: [:])
        Self.sharedWebClient.load(resource: resource) { [weak self] response in
            guard let controller = self else { return }
            DispatchQueue.main.async { [self] in
                controller.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                print(response.value as Any)
                if response.value?.code == 200 || response.value?.code == 201{
                    self?.showAlert(title: "", message: response.value?.message ?? "", alertCompletionHandler: { (status) in
                        self?.navigateToHome()
                    })
                }else if let error = response.error {
                    controller.handleError(error)
                }else{
                    self?.showAlert(message: LocalizationManager.shared.localizedString(key1: "Common", key2: "unknownErrorText"))
                }
            }
        }*/
    }
    
    func deleteOrderRequest() {
        
        self.view.isUserInteractionEnabled = false
        
     /*   let path:String = Config.API.apiOrderStatusUpdateRequest
        let postData: [String:Any] = ["order_id": "\(self.orderId)",
                                      "comments":self.reasonTextView.textView.text ?? "",
                                      "action": self.orderStatusType]
        
        let resource = Resource<DMSOrderDelete,
                                DMSError>(jsonDecoder: JSONDecoder(),
                                          path: path,
                                          method: .post,
                                          params: postData,
                                          headers: [:])
        Self.sharedWebClient.load(resource: resource) { [weak self] response in
            guard let controller = self else { return }
            DispatchQueue.main.async { [self] in
                controller.activityIndicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                print(response.value as Any)
                if response.value?.code == 200 || response.value?.code == 201{
                    self?.showAlert(title: "", message: response.value?.message ?? "", alertCompletionHandler: { (status) in
                        self?.dismiss(animated: true, completion: nil)
                    })
                }else if let error = response.error {
                    controller.handleError(error)
                }else{
                    self?.showAlert(message: LocalizationManager.shared.localizedString(key1: "Common", key2: "unknownErrorText"))
                }
            }
        }*/
    }
    
    @objc func deleteOrderButtonTapped(_ sender: UIButton) {
            self.deleteOrder()
    }
    
    @objc func deleteRequestOrderButtonTapped(_ sender: UIButton) {
        if self.reasonTextView.textView.text == "" {
            UIAlertController.showAlert(message: "Please enter reason to continue", target: self)
        }else{
            if self.appDelegate().userDetails.userRole == .manager || self.appDelegate().userDetails.userRole == .staff  {
                self.deleteOrderRequest()
            }
        }
    }
    
    @objc func deleteOrderCancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
 
    func navigateToHome() {
        let vc = self.navigationController?.viewControllers.first(where: { (controller) -> Bool in
            return controller.isKind(of: TabBarVC.self)
        })
        if vc != nil{
            self.navigationController?.popToViewController(vc!, animated: true)
            return
        }
        
        NotificationCenter.default.post(name: .reloadNotificationVC, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func backToHomeVC() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 50.0 // Padding between the bottom of the view and the top of the keyboard
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        guard let activeField = activeView, let keyboardHeight = keyboardSize?.height else { return }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + verticalPadding, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        let activeRect = activeField.convert(activeField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeRect, animated: false)
       
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

extension PopUpView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeView = textView
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      
        activeView = nil
        self.view.endEditing(true)
        textView .resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height+50)
        textView.frame = newFrame;

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 5000    // 5000 Limit Value
    }
    
}

extension PopUpView: UIGestureRecognizerDelegate {
    // MARK: UIGestureRecognizerDelegate methods, You need to set the delegate of the recognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: orderDeleteRequestView) == true || touch.view?.isDescendant(of: orderDeleteView) == true{
            return false
         }
         return true
    }
}
