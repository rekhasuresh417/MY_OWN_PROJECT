//
//  UIViewController.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit
import MaterialComponents

extension UIViewController {
  
    static var sharedWebClient = WebClient.init(baseUrl: Config.baseURL, bearerToken: AppDelegate().defaults.string(forKey: Config.Text.signInAccessKey) ?? "", deviceToken: AppDelegate().defaults.string(forKey: Config.Text.pushDeviceKey) ?? "", workspace: AppDelegate().defaults.string(forKey:  Config.Text.currentWorkspaceId) ?? "", preferredLanguage: AppDelegate().defaults.string(forKey: Config.Text.preferredLanguageKey) ?? "")
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func appNavigationBarStyle(moduleType: module = .dms) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
          
            switch moduleType {
            case .dms:
                appearance.backgroundColor =  .primaryColor()
            case .inquiry:
                appearance.backgroundColor = .inquiryPrimaryColor()
            case .fabric:
                appearance.backgroundColor = .primaryColor()
            }
         
            appearance.titleTextAttributes = [
                .font: UIFont.appFont(ofSize: 18.0, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont.appFont(ofSize: 18.0, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            switch moduleType {
            case .dms:
                self.navigationController?.navigationBar.barTintColor =  .primaryColor()
            case .inquiry:
                self.navigationController?.navigationBar.barTintColor = .inquiryPrimaryColor()
            case .fabric:
                self.navigationController?.navigationBar.barTintColor = .primaryColor()
            }
        }
    }
    
    func showCustomBackBarItem() {
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backNavigationItemTapped(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func showCustomPresentedBackBarItem() {
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: self, action: #selector(backPresentItemTapped(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func showBackBarButtonItem() {
        self.navigationItem.hidesBackButton = false
    }
    
    func hideBackBarButtonItem() {
        self.navigationItem.hidesBackButton = true
    }
    
    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func hideNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func appTransparentNavigationBarStyle() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.titleTextAttributes = [
                .font: UIFont.appFont(ofSize: 20.0, weight: .medium),
                .foregroundColor: UIColor.white
            ]
        }
    }
    
    func addNavigationItem(type: [NavigationItemType], align: NavigationItemAlign? = .right) {
        
        var tempItems: [UIBarButtonItem] = []
        
        for item in type {
            switch item {
            case .menu:
                let menuButton = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(toggleMenu(_:)))
                menuButton.tintColor = UIColor.white
                tempItems.append(menuButton)
                break
            case .filter, .filterApply:
                let menuButton = UIBarButtonItem(image: UIImage(named: item == .filterApply ? "ic_filterApply" : "ic_filter"), style: .plain, target: self, action: #selector(filterNavigationItemTapped(_:)))
                menuButton.tintColor = UIColor.white
                tempItems.append(menuButton)
                break
            case .rotate:
                let rotateButton = UIBarButtonItem(image: UIImage(named: "ic_portrait"), style: .plain, target: self, action: #selector(rotateNavigationItemTapped(_:)))
                rotateButton.tintColor = UIColor.white
                tempItems.append(rotateButton)
                break
            case .rotateApply:
                let rotateApplyButton = UIBarButtonItem(image: UIImage(named: "ic_lanscape"), style: .plain, target: self, action: #selector(rotateApplyNavigationItemTapped(_:)))
                rotateApplyButton.tintColor = UIColor.white
                tempItems.append(rotateApplyButton)
                break
            case .delete:
                let buttonItem = UIBarButtonItem(image: UIImage(named: "ic_delete"), style: .plain, target: self, action: #selector(deleteNavigationItemTapped(_:)))
                buttonItem.tintColor = UIColor.white
                tempItems.append(buttonItem)
                break
            case .download:
                let buttonItem = UIBarButtonItem(image: UIImage(named: "ic_fabric_download"), style: .plain, target: self, action: #selector(downloadNavigationItemTapped(_:)))
                buttonItem.tintColor = UIColor.white
                tempItems.append(buttonItem)
                break
            case .sort:
                let sortButton = UIBarButtonItem(image: UIImage(named: "ic_sort"), style: .plain, target: self, action: #selector(sortNavigationItemTapped(_:)))
                sortButton.tintColor = UIColor.white
                tempItems.append(sortButton)
            case .notification:
                let sortButton = UIBarButtonItem(image: UIImage(named: "ic_bell"), style: .plain, target: self, action: #selector(toggleNotification(_:)))
                sortButton.tintColor = UIColor.white
                tempItems.append(sortButton)
            }
        }
        
        if align == NavigationItemAlign.left {
            self.navigationItem.leftBarButtonItems = tempItems
        } else {
            self.navigationItem.rightBarButtonItems = tempItems
        }
    }
    
    @objc func toggleMenu(_ sender: UIBarButtonItem) {}
    
    @objc func toggleNotification(_ sender: UIBarButtonItem) {}
    
    @objc func filterNavigationItemTapped(_ sender: UIBarButtonItem) {}
    
    @objc func sortNavigationItemTapped(_ sender: UIBarButtonItem) {}
    
    @objc func rotateNavigationItemTapped(_ sender: Any) {}
    
    @objc func rotateApplyNavigationItemTapped(_ sender: Any) {}
    
    @objc func refreshNavigationItemTapped(_ sender: Any) {}
    
    @objc func deleteNavigationItemTapped(_ sender: Any) {}
    
    @objc func downloadNavigationItemTapped(_ sender: Any) {}
    
    @objc func backNavigationItemTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backPresentItemTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    static func from(storyBoard: UIStoryboard, withIdentifier: ViewControllerIdentifiers) -> UIViewController {
        return storyBoard.instantiateViewController(withIdentifier: withIdentifier.rawValue)
    }
    
    func addObserver(for name: String, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    func postObserver(for name: String, object: Any? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
    }
    
   func handleCustomError(_ error: WebError<DMSError>){
        switch error {
        case .noInternetConnection:
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "noInternetText"), target: self)
        case .unauthorized:
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "un_authenticated"), target: self)
        case .other:
            UIAlertController.showAlert(message: LocalizationManager.shared.localizedString(key: "unknownErrorText"), target: self)
        case .custom(let error):
            UIAlertController.showAlert(message: error.message ?? "", target: self)
        }
    }
    
    func savePreferredLanguage(id:Int) {
        self.appDelegate().defaults.set(id, forKey: Config.Text.preferredLanguageKey)
    }
    
    //For mobile number validation
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^((0091)|(\\+91)|0?)[6789]{1}\\d{9}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    //For email validation
    func isValidEmail(email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if valid {
            valid = !email.contains("..")
        }
        return valid
    }
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    func onBackPressed() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func sharingLogFile() {
        
        self.showHud()
        
        var dataContent:String = ""
        RMLogs.shared.getAllLogs().forEach { (item) in
            dataContent = dataContent
            + "\(DateTime.formatDate(date: item.timestamp, dateFormat: Date.shareLogTimeFormat))"
            + " | \(UIApplication.release) : iOS-\(UIApplication.version)"
            + " | \(UUID().uuidString) | \(item.message)"
            + "\n"
        }
        
        let filename = self.getDocumentsDirectory().appendingPathComponent("\(DateTime.formatDate(date: Date(), dateFormat: Date.shareLogTimeFormat)).txt")
        
        let fileManger = FileManager.default
        if fileManger.fileExists(atPath: filename.absoluteString){
            do{
                try fileManger.removeItem(atPath: filename.absoluteString)
            }catch let error {
                print("error occurred:\n \(error)")
            }
        }
        
        // UTF-8 string with BOM format
        let BOM = [UInt8(0xef), UInt8(0xbb), UInt8(0xbf)]
        var data = Data()
        data.append(contentsOf: BOM)
        if let data1 = dataContent.data(using: .utf8) {
            data.append(data1)
        }
        let strBom = String(decoding: data, as: UTF8.self) // returning UTF-8 with BOM
        
        do {
            try strBom.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            RMLogs.shared.log(type: LogType.ERROR, tag: self.className, message: "Failed to write a file to share logs.")
            self.hideHud()
            return
        }
        
        var filesToShare = [Any]()
        filesToShare.append(filename)
        
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        activityViewController.title = "Share Log File"
        activityViewController.excludedActivityTypes = []
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
            self.hideHud()
        }
    }
 
    func getRole(roleId: Int) -> UserRole{
        switch roleId {
        case 1:
            return .admin
        case 2:
            return .manager
        case 3:
            return .staff
        case 4:
            return .guest
        case 5:
            return .superviser
        case 6:
            return .Merchandiser
        default:
            return .staff
        }
            
    }
    func getFileSize(url: URL) -> Int64 {
        do {
            let resources = try url.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            print ("\(fileSize)")
            
            return Int64(fileSize)
        } catch {
            print("Error: \(error)")
        }
        
        return 0
    }
  
    func getMonth(dateString: String, formatter: String) -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter //
        dateFormatter.locale = Locale(identifier: LocalizationManager.shared.localizedString(key: "localeIdentifier"))
        guard let date = dateFormatter.date(from: dateString) else {
            return []
        }
        var dateArr: [Int] = []
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        dateArr.append(Int(year) ?? 0)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date)
        dateArr.append(Int(month) ?? 0)
        return dateArr
    }
    
    func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat
        
        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()
        
        dateFormatterGet.dateFormat = expectedFromat
        dateFormatterGet.locale = Locale(identifier: "en_US")
        return dateFormatterGet.string(from: date)
    }
    
    func startDate(startDate: String, formatter: String) -> Date {
        let dateString = startDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatter//
        if let date = dateFormatter.date(from: dateString) {
            print(date)
            return date
        }else{
            return Date()
        }
    }
   
    func sameDate(date: Date) -> Date {
        var nextDate: Date {
            return Calendar.current.date(byAdding: .day, value: 0, to: date)!
        }
        return nextDate
    }
    
    func previousDate(date: Date) -> Date {
        var previousDate: Date {
            return Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }
        return previousDate
    }
 
    func random9DigitString() -> String {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 999_999_999
        let i = min + arc4random_uniform(max - min + 1)
        return String(i)
    }
    
    func getAttributedText(firstString:String,firstFont:UIFont,firstColor:UIColor,
                           secondString:String,secondFont:UIFont,secondColor:UIColor) -> NSMutableAttributedString {
        let att = NSMutableAttributedString(string: "\(firstString)\(secondString)");
        att.addAttributes([NSAttributedString.Key.foregroundColor : firstColor, NSAttributedString.Key.font : firstFont], range: NSRange(location: 0, length: firstString.count))
        att.addAttributes([NSAttributedString.Key.foregroundColor : secondColor, NSAttributedString.Key.font : secondFont], range: NSRange(location: firstString.count, length: secondString.count))
        return att
    }
 
    func addDoneButtonOnKeyboard(textField: UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
   
    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }

    func setup(_ textField: MDCOutlinedTextField, placeholderLabel: String, color: UIColor = .primaryColor()) {
        
        textField.label.text = placeholderLabel
        textField.placeholder = ""
        textField.tintColor = color
        
        textField.setOutlineColor(.gray, for: .normal)
        textField.setOutlineColor(color, for: .editing)
        
        textField.setFloatingLabelColor(.gray, for: .normal)
        textField.setFloatingLabelColor(color, for: .editing)
        
        textField.setNormalLabelColor(.gray, for: .normal)
        textField.setNormalLabelColor(color, for: .editing)
        
        textField.setTextColor(.customBlackColor(), for: .normal)
        textField.setTextColor(.customBlackColor(), for: .editing)
        
        textField.sizeToFit()
    }
    
    func setupMDCTextArea(_ textArea: MDCOutlinedTextArea, placeholderLabel: String) {
        textArea.label.text = placeholderLabel
        textArea.tintColor = .primaryColor()
        
        textArea.setOutlineColor(.lightGray, for: .normal)
        textArea.setOutlineColor(.primaryColor(), for: .editing)
        
        textArea.setFloatingLabel(.lightGray, for: .normal)
        textArea.setFloatingLabel(.primaryColor(), for: .editing)
        
        textArea.setNormalLabel(.lightGray, for: .normal)
        textArea.setNormalLabel(.primaryColor(), for: .editing)
        
        textArea.setTextColor(.customBlackColor(), for: .normal)
        textArea.setTextColor(.customBlackColor(), for: .editing)
        
        textArea.sizeToFit()
        
    }
 
    func showAlertWithTextField(title:String, textFieldText: String, placeHolderText: String, firstButtonTitle:String, secondButtonTitle:String, alertCompletionHandler: @escaping (_ text: String,_ status: Int) -> ()) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let first = UIAlertAction(title: firstButtonTitle, style: .destructive, handler: { [weak alert] (_) in
            alertCompletionHandler("", 0)
            alert?.dismiss(animated: true, completion: nil)
        
        })

        alert.addAction(first)
        
        let second = UIAlertAction(title: secondButtonTitle, style: .default, handler: { [weak alert] (_) in
            if let hasTextField = alert?.textFields?[0] {
              alertCompletionHandler(hasTextField.text ?? "", 1)
          }
        })
    
        if textFieldText.isEmpty{
            second.isEnabled = false // Disable at initial state
        }
        
        alert.addAction(second)
        
        alert.addTextField { (textField) in
            textField.text = textFieldText
            textField.placeholder = placeHolderText
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                second.isEnabled = (textField.text ?? "").count > 0
            }
        }
  
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupPickerViewWithToolBar(textField: UITextField,
                                    target: UIViewController?,
                                    thePicker: UIPickerView,
                                    isFromInquiry: Bool = false,
                                    isCancelButtonNeeded: Bool? = false){
        thePicker.dataSource = target as? UIPickerViewDataSource
        thePicker.delegate = target as? UIPickerViewDelegate
        textField.inputView = thePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        toolBar.tintColor = isFromInquiry == true ? .inquiryPrimaryColor() : .primaryColor()
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "doneButtonText"), style: .plain, target: self, action: #selector(self.doneButtonTapped(_:)))
        let cancelButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(key: "cancelButtonText"), style: .plain, target: self, action: #selector(cancelPickerButtonTapped(_:)))
        if isCancelButtonNeeded ?? false == true{
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }else{
            toolBar.setItems([spaceButton, doneButton], animated: false)
        }
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion:nil)
    }
    
    @objc func doneButtonTapped(_ sender:AnyObject){}
    @objc func cancelPickerButtonTapped(_ sender: UIButton){}
 
    func uploadImageToServer(url: String, params:[String: Any], myImage: UIImage, completion: @escaping (_ response: InquiryFileUploadResponse?, _ error: String?) -> Void){
    
        self.showHud()
       guard let mediaImage = Media(withImage: myImage, forKey: "file") else { return }
       guard let url = URL(string: url) else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       //create boundary
       let boundary = generateBoundary()
       //set content type
       request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
      
        // Add token
        let hasToken = RMConfiguration.shared.accessToken
        if hasToken.count > 0, !hasToken.isEmpty{
            request.addValue("Bearer \(hasToken)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("iOS", forHTTPHeaderField: "platform")
        request.addValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: "device-id")
        request.addValue(UIDevice.current.systemVersion, forHTTPHeaderField: "os-version")
        request.addValue(UIApplication.release, forHTTPHeaderField: "app-version")
        request.addValue(UIDevice.current.model, forHTTPHeaderField: "mobile-model")
        
       //call createDataBody method
       let dataBody = createDataBody(withParameters: params, media: [mediaImage], boundary: boundary)
       request.httpBody = dataBody
       let session = URLSession.shared
       session.dataTask(with: request) { (data, response, error) in
          if let response = response {
             print(response)
          }
           self.hideHud()
           
          if let data = data {
             do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                 
                 let decoder = JSONDecoder()
                 do {
                     let response = try decoder.decode(InquiryFileUploadResponse.self, from: data)
                     DispatchQueue.main.async { completion (response,
                                                            error?.localizedDescription) }
                 } catch {
                     print(error.localizedDescription)
                     DispatchQueue.main.async { completion (nil,
                                                            error.localizedDescription) }
                 }
                 
             } catch {
                 DispatchQueue.main.async { completion (nil,
                                                        error.localizedDescription) }
                print(error)
             }
          }
       }.resume()
    }
    
    func generateBoundary() -> String {
       return "Boundary-\(NSUUID().uuidString)"
    }
    func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                print(key, value)
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
            }
        }
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
//    func uploadFile(parameters:[String:Any], fileData:Data, fileName:String , completion: @escaping (_ fileURL:String?, _ error:String?) -> Void) {
//            print("FILENAME: \(fileName)")
//
//            let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
//            let contentType: String = "multipart/form-data; boundary=\(boundary)"
//
//            let request = NSMutableURLRequest()
//            print("API CALL:", Config.baseURL + "/" + Config.API.LABEL_FILE_UPLOAD)
//            request.url = URL(string: Config.baseURL + "/" + Config.API.LABEL_FILE_UPLOAD)
//            request.httpShouldHandleCookies = false
//            request.timeoutInterval = 60
//            request.httpMethod = "POST"
//            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//
//            let body = NSMutableData()
//            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"fileName\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//            body.append("\(fileName)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n".data(using: String.Encoding.utf8)!)
//
//            // File is an image
//            if fileName.hasSuffix(".jpg") || fileName.hasSuffix(".png") {
//                body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
//            // File is a video
//            } else if fileName.hasSuffix(".mp4") {
//                body.append("Content-Type:video/mp4\r\n\r\n".data(using: String.Encoding.utf8)!)
//            }
//
//            body.append(fileData)
//            body.append("\r\n".data(using: String.Encoding.utf8)!)
//
//
//            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//            request.httpBody = body as Data
//            let session = URLSession.shared
//            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//                guard let _:Data = data as Data?, let _:URLResponse = response, error == nil else {
//                    DispatchQueue.main.async { completion(nil, error!.localizedDescription) }
//                    return
//                }
//                if let response = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
//                    print("XSUploadFile -> RESPONSE: " + response)
//                    DispatchQueue.main.async { completion(response, nil) }
//
//                // NO response
//                } else { DispatchQueue.main.async { completion(nil, "Error") } }// ./ If response
//            }; task.resume()
//        }
//
}

enum NavigationItemType {
    case menu
    case filter
    case filterApply
    case sort
    case rotate
    case rotateApply
    case delete
    case download
    case notification
}

enum NavigationItemAlign {
    case left
    case right
}

enum ViewControllerIdentifiers: String {
    
    case signIn = "SignInVC"
    case signUp = "SignUpVC"
    
    case language = "LanguageSelectionVC"
    case appManual = "AppManualVC"
    case newUser = "NewUserVC"
    case emailVerify = "EmailVerifyVC"
    case authenticationCode = "AuthenticationCodeVC"
    case newPassword = "NewPasswordVC"
    
    case companySetting = "CompanySettingVC"
    case webView = "WebViewVC"

    case main = "MainVC"
    case tabBar = "TabBarVC"
    case home = "HomeVC"
    case workspace = "WorkspaceVC"
    case menuBar = "MenuBarVC"
    
    case notification = "NotificationVC"
    case onGoingList = "OnGoingListVC"
    case onGoingFilter = "OngoingListFilterVC"
    case otpVerification = "VerifyOTPSignInVC"
    case orderInfo = "OrderInfoVC"
    case addNewContact = "AddNewContactVC"
    case newOrder = "NewOrderVC"
  
    case popUpView =  "PopUpView"
    
    case taskUpdate = "TaskUpdateVC"
    case taskInput = "TaskInputVC"
    case orderFilter = "OrderFilterVC"
  
    case productionUpdate = "ProductionUpdateVC"
    case updateActualProd = "UpdateActualProdVC"
    case dataInputUpdate = "DataInputUpdateVC"
    
    case contactList = "ContactListVC"
    
    case addNewSKU = "SKUAddNewColorOrSize"
    case addNewSKUQuantity = "SKUAddQuantityVC"
    case viewSKU = "SKUViewVC"
    case addSKU = "SKUAddVC"
    
    case holidayList = "HolidaysListVC"
    case viewHolidayList = "ViewHolidayListVC"
    
    case taskRescheduleHistory = "TaskRescheduleHistoryVC"
    case taskScheduleDate = "TaskScheduleDateVC"
    case taskReAssignPIC = "TaskReAssignPICVC"
    case taskUpdateEdit = "TaskUpdate_EditVC"
    case taskRescheduleDate = "TaskRescheduleDateVC"
    case addSubTask = "AddSubTaskVC"
    case taskUpdateFilter = "TaskUpdateFilterVC"
    case taskFileList = "TaskFileListVC"
    //case concernedMembers = "ConcernedMembersVC"
    
    case userSettings = "UserSettingsVC"
    
    case reOrderTasks = "ReOrderTasks"
    case addNewTask = "AddNewTaskVC"
    
    case pendingTaskFilter = "PendingTaskFilterVC"
    case orderListFilter = "OrderListFilterVC"
    case orderListSort = "OrderListSortVc"
    case orderStatusPopup = "OrderStatusPopupVC"
    
    case previewOrderStatus = "PreviewOrderStatusVC"
    case orderStatusFilter = "OrderStatusFilterVC"
    
    case addProduction = "AddProductionVC"
    
    // Inquiry
    case inquiryDashboard = "InquiryDashboardVC"
    case inquiryList = "InquiryListVC"
    case inquiryStatus = "InquiryStatusVC"
    case sendQuotation = "SendQuotationVC"
    case pdfView = "PDFViewVC"
    case factoryResponse = "FactoryResponseVC"
    case addFactoryResponse = "AddFactoryResponseVC"
    case inquiryFilter = "InquiryFilterVC"
    case inquiryFactoryContact = "InquiryFactoryContactVC"
    case addFactoryContact = "AddFactoryContactVC"
    case purchaseOrderList = "PurchaseOrderListVC"
    case materialsAndLabelsList = "MaterialsAndLabelsListVC"
    case inquiryPOMultiImage = "InquiryPOMultiImageVC"
    case inquiryChatContent = "InquiryChatContentVC"
    case test = "TestVC"
    
    // Fabric
    case fabricDashboard = "FabricDashboardVC"
    case fabricInquiryList = "FabricInquiryListVC"
    case createNewFabricInquiry = "CreateNewFabricInquiryVC"
    case detailsFabricInquiry = "DetailsFabricInquiryVC"
    case fabricInquiryFilter = "FabricInquiryFilterVC"
    case selectFabricSuppliers = "SelectFabricSuppliersVC"
    case createNewSuppliersVC = "CreateNewSuppliersVC"
    case addViewSuppliersResponse = "AddViewSuppliersResponseListVC"
    case addSupplierResponse =  "AddSupplierResponseVC"
    case suppliersResponse = "SuppliersResponseVC"
    case fabricPDF = "FabricPDFVC"
}

extension Array where Element: Hashable {
   func removingDuplicates() -> [Element] {
       var addedDict = [Element: Bool]()
       
       return filter {
           addedDict.updateValue(true, forKey: $0) == nil
       }
   }
   
   mutating func removeDuplicates() {
       self = self.removingDuplicates()
   }
}

enum module {
    case dms
    case inquiry
    case fabric
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
         print("data======>>>",data)
      }
   }
}
