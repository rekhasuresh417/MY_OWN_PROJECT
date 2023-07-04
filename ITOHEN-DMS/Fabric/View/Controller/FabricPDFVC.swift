//
//  FabricPDFVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 04/04/23.
//

import UIKit
import WebKit

class FabricPDFVC: UIViewController {
   
    @IBOutlet var webView: WKWebView!

    var isFromInquiryList: Bool = false
    var pdfURL: String = ""
    var screenTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWkWebview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .fabric)
        self.title = isFromInquiryList == true ? LocalizationManager.shared.localizedString(key: "fabricInquiryPDFText") : LocalizationManager.shared.localizedString(key: "supplierResponsePDFText")
    }
    
    func loadWkWebview(){
      //  self.showHud()
        
        self.webView.isOpaque = false
        self.webView.backgroundColor = .clear
        
//        let link = URL(string: pdfURL)!
//        let request = URLRequest(url: link)
//        self.webView.navigationDelegate = self
//        self.webView.load(request)
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FabricPDFVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hideHud()
        print("Error while loading", error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
        self.hideHud()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideHud()
        print("finish to load")
    }
    
}
