//
//  AddNewTaskVC.swift
//  Itohen-dms
//
//  Created by Dharma on 22/01/21.
//

import UIKit
import MaterialComponents

protocol TaskInputAddNewTaskOrCategoryDelegate {
    func addedNewTaskOrCategoryFor(_ section:Int?, type:TemplateAddNew, taskData:String, categoryData:TaskTemplateStructure?)
}

class AddNewTaskVC: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var contentView:UIView!
    @IBOutlet var topView:UIView!
    @IBOutlet var sectionView:UIView!
    @IBOutlet var sectionTitleLabel:UILabel!
    @IBOutlet var firstTextField:MDCOutlinedTextField!
    @IBOutlet var secondTextField:MDCOutlinedTextField!
    @IBOutlet var thirdTextField:MDCOutlinedTextField!
    @IBOutlet var addButton:UIButton!
    @IBOutlet var swipeToDownButton:UIButton!
    @IBOutlet var secondTextFieldHConstraint: NSLayoutConstraint!
    @IBOutlet var thirdTextFieldHConstraint: NSLayoutConstraint!
    
    var delegate:TaskInputAddNewTaskOrCategoryDelegate?
    var section:Int = 0
    weak var activeField: UITextField?
    var type:TemplateAddNew = .category
    var taskData = [String]()
    var getAllContacts: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewTaskVC.keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewTaskVC.keyboardWillBeHidden),
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
        sectionTitleLabel.text =  self.type == .task ? LocalizationManager.shared.localizedString(key: "sectionTaskTitle") : LocalizationManager.shared.localizedString(key: "sectionCategoryTitle")
        
        [firstTextField, secondTextField, thirdTextField].forEach { (theTextField) in
            theTextField?.delegate = self
            theTextField?.textAlignment = .left
            theTextField?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
            theTextField?.textColor = .customBlackColor()
            theTextField?.keyboardType = .default
            theTextField?.autocapitalizationType = .sentences
            
            if self.type == .task{
                self.setup(firstTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "taskPlaceHolderText"))
                self.secondTextField.isHidden = true
                self.thirdTextField.isHidden = true
                self.secondTextFieldHConstraint.constant = 0.0
                self.thirdTextFieldHConstraint.constant = 0.0
            }else{
                self.secondTextField.isHidden = false
                self.thirdTextField.isHidden = false
                self.secondTextFieldHConstraint.constant = 60.0
                self.thirdTextFieldHConstraint.constant = 60.0
                self.setup(firstTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "categoryPlaceHolderText"))
                self.setup(secondTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "taskPlaceHolderText"))
                self.setup(thirdTextField, placeholderLabel: LocalizationManager.shared.localizedString(key: "taskPlaceHolderText"))
            }
          
        }
        
        self.swipeToDownButton.layer.cornerRadius = 2.0
        self.swipeToDownButton.backgroundColor = .white

        self.addButton.isUserInteractionEnabled = false
        self.addButton.backgroundColor = .lightGray
        self.addButton.layer.cornerRadius = self.addButton.frame.height / 2.0
        self.addButton.setTitle(LocalizationManager.shared.localizedString(key: "addButtonText"), for: .normal)
        self.addButton.setTitleColor(.white, for: .normal)
        self.addButton.titleLabel?.font = UIFont.appFont(ofSize: 15.0, weight: .regular)
        self.addButton.addTarget(self, action: #selector(self.addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        if self.type == .task{
            self.delegate?.addedNewTaskOrCategoryFor(self.section, type: self.type, taskData: self.firstTextField.text ?? "", categoryData: nil)
        }else{
            if secondTextField.text != ""{
                taskData.append(self.secondTextField.text ?? "")
            }
            if thirdTextField.text != ""{
                taskData.append(self.thirdTextField.text ?? "")
            }
            self.delegate?.addedNewTaskOrCategoryFor(nil, type: self.type, taskData: "", categoryData: TaskTemplateStructure.init(taskTitle: self.firstTextField.text ?? "", taskSubTitles: taskData))
        }
            
        self.dismissViewController()
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

extension AddNewTaskVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        if text.isEmptyOrWhitespace(){
            self.addButton.isUserInteractionEnabled = false
            self.addButton.backgroundColor = .lightGray
        }else{
            self.addButton.isUserInteractionEnabled = true
            self.addButton.backgroundColor = .primaryColor()
        }
        if textField == self.firstTextField{
            return newLength <= 100
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

enum TemplateAddNew {
    case category
    case task
}
