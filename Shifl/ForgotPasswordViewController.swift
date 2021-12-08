//
//  ForgotPasswordViewController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 08/12/21.
//

import UIKit
import WebKit

class ForgotPasswordViewController: UIViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(webView)
        let url = URL(string: "https://app.shifl.com/forgetPassword")
        webView.load(URLRequest(url: url!))
    }
}
