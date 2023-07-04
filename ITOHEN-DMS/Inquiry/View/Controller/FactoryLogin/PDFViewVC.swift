//
//  PDFViewVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 01/02/23.
//

import UIKit
import WebKit

class PDFViewVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var pdfURL: String?
    var isFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWkWebview()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle(moduleType: .inquiry)
        if isFrom == "PO"{
            self.title = LocalizationManager.shared.localizedString(key: "viewPOText")
        }else{
            self.title = LocalizationManager.shared.localizedString(key: "inquiryDetailText")
        }
    }
    
    func loadWkWebview(){
        
        self.webView.isOpaque = false
        self.webView.backgroundColor = .clear
        
        if let url = pdfURL, let link = URL(string: url){
            self.showHud()
            let request = URLRequest(url: link)
            self.webView.navigationDelegate = self
            self.webView.load(request)
        }
     
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PDFViewVC: WKNavigationDelegate {
    
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

