//
//  LoginViewController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 06/12/21.
//

import UIKit
import TTGSnackbar

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let generator = UINotificationFeedbackGenerator()
    let toolbar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    lazy var activityIndicatorView: UIView = {
        let uiVIew = UIView(frame: self.view.bounds)
        uiVIew.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activity.center = uiVIew.center
        activity.startAnimating()
        uiVIew.addSubview(activity)
        return uiVIew
    }()
    
    let snackbar: TTGSnackbar = {
        let snack = TTGSnackbar(message: "Account not found", duration: .middle)
        snack.leftMargin = 15
        snack.rightMargin = 15
        return snack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.font = UIFont(name: "Inter-SemiBold", size: 20)
        label.textColor = UIColor(named: "text_color_black")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let field = UITextField(frame: .zero)
        field.placeholder = "e.g. abcdefghij@email.com"
        field.borderStyle = .roundedRect
        field.text = "david@tpro.com"
        field.layer.cornerRadius = 4
        field.layer.borderColor = UIColor.gray.cgColor
        field.font = UIFont(name: "Inter-Regular", size: 14)
        field.translatesAutoresizingMaskIntoConstraints = false
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped(_:)))
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "primary_color") as Any], for: .normal)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = [flexibleButton,doneBtn]
        toolbar.sizeToFit()
        field.inputAccessoryView = toolbar
        
        return field
    }()
    
    lazy var passwordTextField: UITextField = {
        let field = UITextField(frame: .zero)
        let button = UIButton()
        
        field.placeholder = "Type your password"
        field.text = "Davidshifl976"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.font = UIFont(name: "Inter-Regular", size: 14)
        field.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: "visibility_on_icon"), for: .normal)
        button.setTitleColor(UIColor(named: "primary_color"), for: .selected)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped(_:)))
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "primary_color") as Any], for: .normal)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = [flexibleButton,doneBtn]
        toolbar.sizeToFit()
        field.inputAccessoryView = toolbar
        
        view.addSubview(field)
        field.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: field.topAnchor),
            button.bottomAnchor.constraint(equalTo: field.bottomAnchor),
            button.centerYAnchor.constraint(equalTo: field.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: field.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 50),
        ])
        button.addTarget(self, action: #selector(togglePassword(sender:)), for: .touchUpInside)
        return field
    }()
    
    @objc func onDoneButtonTapped(_ sender: UIBarButtonItem) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc
    func togglePassword(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            sender.setImage(UIImage(named: "visibility_off_icon"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "visibility_on_icon"), for: .normal)
        }
        passwordTextField.isSecureTextEntry.toggle()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    lazy var loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = UIColor(named: "primary_color")
        button.layer.cornerRadius = 4
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var forgotPasswordBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "primary_color"), for: .normal)
        button.addTarget(self, action: #selector(openForgotPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var card: UIView = {
        let frame = UIView()
        frame.backgroundColor = UIColor.white
        frame.layer.cornerRadius = 4
        frame.translatesAutoresizingMaskIntoConstraints = false
        return frame
    }()
    
    lazy var logo: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var checkboxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkbox"), for: .normal)
        button.setImage(UIImage(named: "checkbox_checked"), for: .selected)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var rememberMeLabel: UILabel = {
        let label = UILabel()
        label.text = "Remember me"
        label.numberOfLines = 0
        label.font = UIFont(name: "Inter-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg_color_blue")
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.configUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if UserDefaults.standard.string(forKey: "USER_EMAIL") != nil {
            emailTextField.text = UserDefaults.standard.string(forKey: "USER_EMAIL")
        }

        if UserDefaults.standard.string(forKey: "USER_PASSWORD") != nil {
            passwordTextField.text = UserDefaults.standard.string(forKey: "USER_PASSWORD")
        }
    }
    
    @objc
    func checkboxTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func showSpinner() {
        self.view.addSubview(activityIndicatorView)
    }
    
    func removeSpinner() {
        activityIndicatorView.removeFromSuperview()
    }
    
    @objc
    func openForgotPassword(sender: UIButton) {
        let forgotPassword = ForgotPasswordViewController()
        let navVC = UINavigationController(rootViewController: forgotPassword)
        navVC.modalPresentationStyle = .popover
        present(navVC, animated: true, completion: nil)
    }
    
    @objc
    func login() {
        showSpinner()
        
        // if user tick remember me button
        if checkboxButton.isSelected {
            UserDefaults.standard.set(emailTextField.text!, forKey: "USER_EMAIL")
            UserDefaults.standard.set(passwordTextField.text!, forKey: "USER_PASSWORD")
        }
        
        // animate button click
        
        UIButton.animate(withDuration: 0.2, animations: {
            self.loginBtn.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        }, completion: { finish in
            UIButton.animate(withDuration: 0.2, animations: {
                self.loginBtn.transform = CGAffineTransform.identity
            })
        })
        
        APIManager.shared.login(email: emailTextField.text!, password: passwordTextField.text!) { result in
            self.generator.notificationOccurred(.success)
            DispatchQueue.main.async {
                self.removeSpinner()
                let dashboardVC = DashboardController()
                let navVC = UINavigationController(rootViewController: dashboardVC)
                navVC.modalPresentationStyle = .overFullScreen
                self.present(navVC, animated: true, completion: nil)
            }
        }
        
        
        
//        let url = URL(string: "https://beta.shifl.com/api/login")
//        guard let requestUrl = url else { fatalError() }
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//
//        let postString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)";
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            let response = response as! HTTPURLResponse
//            let status = response.statusCode
//            if status == 404 {
//                DispatchQueue.main.async {
//                    self.removeSpinner()
//                    self.snackbar.show()
//                }
//                self.generator.notificationOccurred(.error)
//                return
//            }
//
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//
//            do {
//                let result = try JSONDecoder().decode(LoginModel.self, from: data!)
//                let expiresAt = Int(Date().timeIntervalSince1970) + result.expiresIn
//                let token = result.token
//
//                KeychainHelper.shared.save(Data(token.utf8), service: "token", account: "shifl")
//
//                UserDefaults.standard.set(expiresAt, forKey: "expiresAt")
//                self.generator.notificationOccurred(.success)
//                DispatchQueue.main.async {
//                    let dashboardVC = ViewController()
//                    let navVC = UINavigationController(rootViewController: dashboardVC)
//                    navVC.modalPresentationStyle = .overFullScreen
//                    self.present(navVC, animated: true, completion: nil)
//                }
//            } catch {
//                self.removeSpinner()
//                fatalError()
//            }
//        }
//        task.resume()
    }
    
    private func configUI() {
        view.addSubview(card)
        view.addSubview(logo)
        view.addSubview(activityIndicator)
        card.addSubview(titleLabel)
        card.addSubview(emailTextField)
        card.addSubview(passwordTextField)
        card.addSubview(loginBtn)
        card.addSubview(forgotPasswordBtn)
        card.addSubview(checkboxButton)
        card.addSubview(rememberMeLabel)
        
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            card.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            card.heightAnchor.constraint(equalToConstant: 350),
            
            logo.heightAnchor.constraint(equalToConstant: 36),
            logo.widthAnchor.constraint(equalToConstant: 150),
            logo.bottomAnchor.constraint(equalTo: card.safeAreaLayoutGuide.topAnchor, constant: -20),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailTextField.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            checkboxButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            checkboxButton.leadingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            checkboxButton.widthAnchor.constraint(equalToConstant: 18),
            checkboxButton.heightAnchor.constraint(equalToConstant: 18),
            
            rememberMeLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            rememberMeLabel.leadingAnchor.constraint(equalTo: checkboxButton.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            
            forgotPasswordBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            forgotPasswordBtn.trailingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            forgotPasswordBtn.heightAnchor.constraint(equalToConstant: 18),
            
            loginBtn.topAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: 30),
            loginBtn.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            loginBtn.leadingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            loginBtn.trailingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            loginBtn.heightAnchor.constraint(equalToConstant: 40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
