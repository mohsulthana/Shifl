//
//  ViewController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 06/12/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let token = UserDefaults.standard.string(forKey: "token")
    
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        let js = "localStorage.setItem('user_token', '\(token!)'); localStorage.setItem('expiresAt', '300')"
        let userScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        view = webView
        
//        localStorage.setItem("user_token", res.data.token)
//        // optional
//        new Date(new Date()
//                    .getTime() + (res.data.expiresIn - 2) * 1000
//        localStorage.setItem("expiresAt", expiresAt)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://app.shifl.com/shipments")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
}
