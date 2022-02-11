//
//  DashboardController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 06/12/21.
//

import UIKit
import WebKit
import TTGSnackbar

class DashboardController: UIViewController, WKNavigationDelegate, URLSessionDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    let token = UserDefaults.standard.string(forKey: "token")
    let expiresAt = UserDefaults.standard.string(forKey: "expiresAt")
//    var url = URL(string: "https://app.shifl.com/shipments")!
    var url = URL(string: "http://localhost:8081/shipments")!
    var loggedIn: Bool?
    var height: Double?
    let refreshControl = UIRefreshControl()
    
    lazy var snackbar: TTGSnackbar = {
        let snack = TTGSnackbar(message: "You are signed in", duration: .middle)
        snack.leftMargin = 15
        snack.rightMargin = 15
        return snack
    }()
    
    lazy var webView: WKWebView = {
        
        let configuration = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        configuration.defaultWebpagePreferences = prefs
        let contentController = WKUserContentController()
        let userTokenScript = "localStorage.setItem('user_token', '\(token!)')"
        let expiresAtScript = "localStorage.setItem('expiresAt', '\(expiresAt!)')"
        let logoutJs = "var btn = document.getElementsByClassName('btn-logout'); btn.setAttribute('id', 'btnLogout')"
        let logoutScript = WKUserScript(source: logoutJs, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        let tokenScript = WKUserScript(source: userTokenScript, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        let expiresScript = WKUserScript(source: expiresAtScript, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        contentController.addUserScript(tokenScript)
        contentController.addUserScript(expiresScript)
        contentController.addUserScript(logoutScript)
        configuration.userContentController = contentController
        contentController.add(self, name: "buttonClicked")
        
        let webview = WKWebView(frame: .zero,
                                configuration: configuration)
        
        return webview
    }()
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody:NSDictionary = message.body as? NSDictionary{
            
            if messageBody != nil {
                // wipe all user's data and back to login VC
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "expiresAt")

                // redirect to login
                let loginVC = LoginViewController()
                let navVC = UINavigationController(rootViewController: loginVC)
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    
    lazy var navCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "primary_color")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.backgroundColor = .systemBackground
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navBarAppearance.backgroundColor = UIColor(named: "primary_color")
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView.navigationDelegate = self
        refreshControl.addTarget(self, action: #selector(reloadWeb(_:)), for: .valueChanged)
        loadWebPage(url: self.url)
        configUI()
        snackbar.show()
    }
    
    let statusBarHeight: CGFloat = {
        var heightToReturn: CGFloat = 0.0
             for window in UIApplication.shared.windows {
                 if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                     heightToReturn = height
                 }
             }
        return heightToReturn
    }()
    
    func configUI() {
        view.addSubview(navCard)
//        webView.scrollView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            navCard.topAnchor.constraint(equalTo: view.topAnchor),
            navCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navCard.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navCard.heightAnchor.constraint(equalToConstant: statusBarHeight)
        ])
    }
    
    func loadWebPage(url: URL?)  {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: url!)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            self.webView.load(URLRequest(url: url!))
            self.webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    @objc func reloadWeb(_ sender: UIRefreshControl) {
        loadWebPage(url: url)
        sender.endRefreshing()
    }
    
    // for future development
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.getElementById('btnLogout')") { (result, error) in
//            print("res \(result)")
//        }
//    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === webView && keyPath == "URL" {
            url = webView.url!
//             print("URL Change 1:", webView.url?.absoluteString ?? "No value provided")
         }
//        if keyPath == #keyPath(WKWebView.url) {
//            print("URL Change 2:", self.webView.url?.absoluteString ?? "# No value provided")
//        }
//        if AuthManager.shared.isSignedIn && AuthManager.shared.shouldRefreshToken {
//            AuthManager.shared.refreshIsNeeded(completion: nil)
//        }
    }
    
    deinit {
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
