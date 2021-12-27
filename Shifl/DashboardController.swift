//
//  DashboardController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 06/12/21.
//

import UIKit
import WebKit

class DashboardController: UIViewController, WKNavigationDelegate, URLSessionDelegate, WKUIDelegate {
    let token = UserDefaults.standard.string(forKey: "token")
    let expiresAt = UserDefaults.standard.string(forKey: "expiresAt")
    var url = URL(string: "https://app.shifl.com/shipments")!
    
    lazy var webView: WKWebView = {
        
        let configuration = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let script = WKUserScript(
            source: "window.localStorage.clear();",
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        configuration.userContentController.addUserScript(script)
        
        configuration.defaultWebpagePreferences = prefs
        let contentController = WKUserContentController()
        let userTokenScript = "localStorage.setItem('user_token', '\(token!)')"
        let expiresAtScript = "localStorage.setItem('expiresAt', '\(expiresAt!)')"
        let tokenScript = WKUserScript(source: userTokenScript, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        let expiresScript = WKUserScript(source: expiresAtScript, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        contentController.addUserScript(tokenScript)
        contentController.addUserScript(expiresScript)
        configuration.userContentController = contentController
        
        let webview = WKWebView(frame: .zero,
                                configuration: configuration)
        
        let jscode = """
        <div id="test" style="height: 40px; width: 100px; background-color: powderblue;">Hello</div>
        <script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
        <script type="text/javascript" src="js/platform.js"></script>

        <script type="text/javascript">
        document.getElementsByClassName("btn-logout")[0].addEventListener("click", function test() {
            window.webkit.messageHandlers.test.postMessage("TEXT");
        });
        </script>
        """
        webview.evaluateJavaScript(jscode) { _, _ in }
        
        return webview
    }()
    
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
        loadWebPage(url: self.url)
        configUI()
    }
    
    func configUI() {
        view.addSubview(navCard)
        
        NSLayoutConstraint.activate([
            navCard.topAnchor.constraint(equalTo: view.topAnchor),
            navCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navCard.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navCard.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func loadWebPage(url: URL)  {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if AuthManager.shared.shouldRefreshToken {
            AuthManager.shared.refreshIsNeeded(completion: nil)
        }
        
//        if keyPath == #keyPath(WKWebView.url) {
//            if self.webView.url?.path.contains("login") == true && countLoginURL > 1 {
//                // wipe all user's data and back to login VC
//                UserDefaults.standard.removeObject(forKey: "token")
//                UserDefaults.standard.removeObject(forKey: "expiresAt")
//
//                // redirect to login
//                let loginVC = LoginViewController()
//                let navVC = UINavigationController(rootViewController: loginVC)
//                navVC.modalPresentationStyle = .fullScreen
//                self.present(navVC, animated: true, completion: nil)
//            }
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
