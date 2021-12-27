//
//  ForgotPasswordViewController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 08/12/21.
//

import UIKit
import WebKit

class ForgotPasswordViewController: UIViewController {
    lazy var webView: WKWebView = {
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pref
        let webview = WKWebView(frame: .zero, configuration: config)
        return webview
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Close", for: .normal)
        backButton.setTitleColor(UIColor.gray, for: .normal)
        backButton.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor(named: "primary_color")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "primary_color") as Any]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        title = "Forget Password"
        
        view.addSubview(webView)
        view.addSubview(backButton)
        let url = URL(string: "https://app.shifl.com/forgetPassword")
        webView.load(URLRequest(url: url!))
    }
    
    @objc
    func close(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    deinit {
        print(#function)
    }
}
 
