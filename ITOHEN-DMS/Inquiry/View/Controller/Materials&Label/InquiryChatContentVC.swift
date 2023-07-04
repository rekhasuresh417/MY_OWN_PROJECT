//
//  InquiryChatContentVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 05/05/23.
//

import UIKit
import AVFoundation
import Photos

class InquiryChatContentVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var imageBackgroundView: UIView!
    @IBOutlet var imageTitleLabel: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var commentTextView: UITextView!{
        didSet { commentTextView?.addDoneCancelToolbar() }
    }
    @IBOutlet var addImageBackgroundView: UIView!
    @IBOutlet var saveButton:UIButton!
    @IBOutlet var cancelButton:UIButton!
   
    @IBOutlet var publishCheckBoxButton: UIButton!
    @IBOutlet var publishLabel: UILabel!
   
    let thePicker = UIPickerView()
    let theToolbarForPicker = UIToolbar()
    weak var activeField: UITextField?
    var data: InquiryPOModel?
    var imageList: [InquiryUploadedFiles]? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    weak var activeTextViewField: UITextView?
    var delegate: AddLabelContentDelegate?
    var userId: String = ""
    var serverURL: String = ""
    var isFrom: String = ""
    var randomNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
       
        RestCloudService.shared.materialsAndLabelDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(InquiryChatContentVC.textViewKeyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InquiryChatContentVC.keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
                                                                         
        if isFrom == Config.UpdateStatus.EDIT{
            randomNumber = self.data?.ref ?? ""
            self.commentTextView.attributedText = (data?.text?.joined(separator: ""))?.htmlToAttributedString
            self.getLabelContent()
            sectionTitleLabel.text = "Edit \(data?.type ?? "")"
            publishCheckBoxButton.isSelected = data?.status == 1 ? true : false
           
        }else{
            self.generateRandomNumber()
            sectionTitleLabel.text = "Add \(data?.type ?? "")"
            publishCheckBoxButton.isSelected = false
        }
        
        print(publishCheckBoxButton.isSelected)
    }
    
    func setupUI(){
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor.init(rgb: 0x000000, alpha: 0.5)
        self.topView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissView))
        self.topView.addGestureRecognizer(tap)
        
        self.sectionView.backgroundColor = .white
        self.sectionView.roundCorners(corners: [.topLeft,.topRight], radius: 30.0)
        sectionTitleLabel.textColor = .customBlackColor()
        sectionTitleLabel.textAlignment = .left
        sectionTitleLabel.font = UIFont.appFont(ofSize: 16.0, weight: .medium)
        self.sectionTitleLabel.text = LocalizationManager.shared.localizedString(key: "addNewFactoryText")
        
        addImageBackgroundView.roundCorners(corners: .allCorners, radius: 8)
      
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.saveButton.backgroundColor = .inquiryPrimaryColor()
        self.saveButton.layer.cornerRadius = self.saveButton.frame.height / 2.0
        self.saveButton.setTitleColor(.white, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.saveButton.setTitle(LocalizationManager.shared.localizedString(key: "saveButtonText"), for: .normal)
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        
        self.cancelButton.backgroundColor = .inquiryPrimaryColor(withAlpha: 0.3)
        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.height / 2.0
        self.cancelButton.setTitleColor(.inquiryPrimaryColor(), for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .semibold)
        self.cancelButton.setTitle(LocalizationManager.shared.localizedString(key: "cancelButtonText"), for: .normal)
        self.cancelButton.layer.borderWidth = 0.5
        self.cancelButton.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        
        self.commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.commentTextView.layer.borderWidth = 0.5
        self.commentTextView.layer.cornerRadius = 8
        self.commentTextView.text = LocalizationManager.shared.localizedString(key: "commantsText")
        self.commentTextView.textColor = UIColor.gray
        self.commentTextView.delegate = self
        
        self.publishCheckBoxButton.addTarget(self, action: #selector(publishCheckBoxButtonTapped(_:)), for: .touchUpInside)
        publishCheckBoxButton.setImage(UIImage(named: Config.Images.checkboxIcon), for: .normal)
        publishCheckBoxButton.setImage(UIImage(named: Config.Images.inq_checkboxTickIcon), for: .selected)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addImagesViewTapView(sender:)))
        addImageBackgroundView.addGestureRecognizer(tapGesture)
    }
  
    func generateRandomNumber(){
        self.randomNumber = self.random9DigitString()
    }
    
    @objc func clearButtonTapped(_ sender: UIBarButtonItem) {
        self.activeField?.text = ""
        self.view.endEditing(true)
    }
 
    @objc func saveButtonTapped(_ sender: UIButton){
        
        if self.inputFieldsValidation() == false{
            return
        }
        
        var content = commentTextView.text
        content = content == LocalizationManager.shared.localizedString(key: "commantsText") ? "" : content
        
        let params:[String:Any] = [
            "company_id" : RMConfiguration.shared.companyId,
            "workspace_id" : RMConfiguration.shared.workspaceId,
            "user_id" : userId,
            "user_type" : RMConfiguration.shared.loginType,
            "type" :  data?.type ?? "",
            "referenceId" : self.randomNumber,
            "inquiry_id" : data?.id ?? "",
            "content" : content ?? "",
            "po_id" : data?.poId ?? "",
            "status" : "0",
            "publish_status" : self.publishCheckBoxButton.isSelected == true ? "1" : "0"]
        print(params)
        self.showHud()
        let type = isFrom == Config.UpdateStatus.ADD ? true : false
        RestCloudService.shared.addLabelContent(params: params, isAdd: type)
    }
   
    private func inputFieldsValidation() -> Bool{
        var content: String = commentTextView.text
        content = content == LocalizationManager.shared.localizedString(key: "commantsText") ? "" : content
        
        var message:String?
      
        if content.isEmptyOrWhitespace(){
            message = "\(LocalizationManager.shared.localizedString(key: "pleaseEntertheCommentsText"))"
        }
        if message != nil{
            UIAlertController.showAlert(message: message ?? "", target: self)
            return false
        }
        return true
    }
    
    func getLabelContent() {
        self.showHud()
        let params: [String:Any] =  [ "referenceId": self.randomNumber,
                                      "inquiry_id": self.data?.id ?? "" ]
        print(params)
        RestCloudService.shared.getLabelContent(params: params)
    }
    
    func deleteLabelContent(mediaId: String) {
        self.showHud()
        let params: [String:Any] =  [ "media_id": mediaId ]
        print(params)
        RestCloudService.shared.deleteLabelContent(params: params)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton){
        self.dismissView()
    }
    
    @objc func dismissView(){
        if imageList?.count ?? 0 > 0{
            DispatchQueue.main.async {
                self.delegate?.getLabelContentList()
            }
        }
        DispatchQueue.main.async {
            self.dismissViewController()
        }

    }
    
    @objc func publishCheckBoxButtonTapped (_ sender: UIButton){
        if sender.isSelected {
            // set deselected
            sender.isSelected = false
        } else {
            // set selected
            sender.isSelected = true
        }
    }
    
    @objc func addImagesViewTapView(sender: UITapGestureRecognizer) {
        self.showHud()
        DispatchQueue.main.async {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
            self.hideHud()
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
 
    @objc func deleteButtonTapped(_ sender: UIButton) {
            
            UIAlertController.showAlert(title: LocalizationManager.shared.localizedString(key: "areYouSureDeleteThisFileText"),
                                        message: LocalizationManager.shared.localizedString(key: "youcantRevertthisBackText"),
                                        firstButtonTitle: LocalizationManager.shared.localizedString(key: "okButtonText"),
                                        secondButtonTitle: LocalizationManager.shared.localizedString(key: "cancelButtonText"),
                                        target: self) { (status) in
                if status == false{
                    
                    
                    DispatchQueue.main.async {
                        if let hasCell = sender.superview?.superview as? MultiImagesCollectionViewCell{
                            print(hasCell.data?.id)
                            if let id = hasCell.data?.id{
                                self.deleteLabelContent(mediaId: "\(id)")
                            }else{
                                self.deleteLabelContent(mediaId: "\(hasCell.data?.media_id ?? 0)")
                            }
                        }
                    }
                }
            }
        }
 
    @objc func textViewKeyboardDidShow(notification: Notification) {
        let verticalPadding: CGFloat = 30.0 // Padding between the bottom of the view and the top of the keyboard
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        guard let activeField = activeTextViewField, let keyboardHeight = keyboardSize?.height else { return }
         
        
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

extension InquiryChatContentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MultiImagesCollectionViewCell
        cell.setContent(data: self.imageList?[indexPath.row], serverURL: "\(serverURL)", target: self)
        return cell
    }
 
}

extension InquiryChatContentVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextViewField = textView
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.layer.borderColor = UIColor.inquiryPrimaryColor().cgColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmptyOrWhitespace() {
            textView.text = LocalizationManager.shared.localizedString(key: "commantsText")
            textView.textColor = UIColor.gray
            textView.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

extension InquiryChatContentVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
      //  self.adjustUITextViewHeight(arg: commentTextView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func adjustUITextViewHeight(arg : UITextView) {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
}

extension InquiryChatContentVC:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK: - ImagePicker Delegate

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //save image
            //display image
            // let imageData = image.jpegData(compressionQuality: 1)
            print("API CALL:", Config.baseURL + Config.API.LABEL_FILE_UPLOAD)
            let params:[String:Any] = [
                "company_id" : RMConfiguration.shared.companyId,
                "inquiry_id" : "\(self.data?.id ?? 0)",
                "po_id" : "\(data?.poId ?? 0)",
                "referenceId" : self.randomNumber,
                "status" :  "0",
                "type" : data?.type ?? "" ,
                "user_id" : userId,
                "user_type" :  RMConfiguration.shared.loginType,
                "workspace_id" : RMConfiguration.shared.workspaceId,
                "publish_status" : self.publishCheckBoxButton.isSelected == true ? "1" : "0"]
            print(params)

            self.uploadImageToServer(url: "\(UIViewController.sharedWebClient.baseUrl)" + Config.API.LABEL_FILE_UPLOAD,
                                     params: params,
                                     myImage: image,
                                     completion: { (response, error) in
                print(response, error)
                if response?.status_code == Config.ErrorCode.SUCCESS {
                    self.serverURL = response?.files?.serverURL ?? ""
                    self.imageList = response?.files?.files
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
  
}

extension InquiryChatContentVC: RCMaterialsAndLabelDelegate{
   
    /// Get Label Content
    func didReceiveGetLabelContent(data: InquiryFileUploadResponse?){
        self.hideHud()
        if isFrom == Config.UpdateStatus.EDIT{
            self.imageList = data?.data?.files
            self.serverURL = data?.data?.serverURL ?? ""
        }else{
            self.imageList = data?.files?.files
            self.serverURL = data?.files?.serverURL ?? ""
        }
    }
    
    func didFailedToReceiveGetLabelContent(errorMessage: String){
        self.hideHud()
    }
   
    /// Add Label Content
    func didReceiveAddLabelContent(message: String?){
        self.hideHud()
        UIAlertController.showAlertWithCompletionHandler(message: String().getAlertSuccess(message: message ?? ""), target: self, alertCompletionHandler: { _ in
            DispatchQueue.main.async {
                self.delegate?.getLabelContentList()
                self.dismissViewController()
            }
        })
    }
    func didFailedToReceiveAddLabelContent(errorMessage: String){
        self.hideHud()
    }
    
    /// Delete Label Content
    func didReceiveDeleteLabelContent(message: String?){
        self.hideHud()
        self.getLabelContent()
    }
    func didFailedToReceiveDeleteLabelContent(errorMessage: String){
        self.hideHud()
    }
    
}
