//
//  AppManualVC.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 26/12/22.
//

import UIKit
import WebKit

class AppManualVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.loadWkWebview()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
        self.showCustomBackBarItem()
        self.appNavigationBarStyle()
        self.title = LocalizationManager.shared.localizedString(key: "appManualText")
    }
    
    func loadWkWebview(){
        self.showHud()
        let link = URL(string:"https://dms.catech.co.in/DMS-Mobile-Manual.pdf")!
        let request = URLRequest(url: link)
        self.webView.navigationDelegate = self
        self.webView.load(request)
    }
    
    override func backNavigationItemTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension AppManualVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hideHud()
        print("Error while loading", error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideHud()
        print("finish to load")
    }
    
}
