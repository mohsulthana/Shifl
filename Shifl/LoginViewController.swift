//
//  LoginViewController.swift
//  Shifl
//
//  Created by Mohammad Sulthan on 06/12/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
        return field
    }()
    
    lazy var passwordTextField: UITextField = {
        let field = UITextField(frame: .zero)
        field.placeholder = "Type your password"
        field.text = "Davidshifl976"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.font = UIFont(name: "Inter-Regular", size: 14)
        field.setIcon(UIImage(named: "visibility_on_icon")!)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg_color_blue")
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.configUI()
    }
    
    @objc
    func checkboxTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc
    func openForgotPassword(sender: UIButton) {
        let forgotPassword = ForgotPasswordViewController()
        forgotPassword.modalPresentationStyle = .overCurrentContext
        forgotPassword.navigationItem.largeTitleDisplayMode = .never
        forgotPassword.title = "Forget Password"
        forgotPassword.navigationController?.navigationBar.backgroundColor = .red
        self.present(UINavigationController(rootViewController: forgotPassword), animated: true, completion: nil)
    }
    
    @objc
    func login() {
        // Prepare URL
        let url = URL(string: "https://beta.shifl.com/api/login")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "email=\(emailTextField.text!)&password=\(passwordTextField.text!)";
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
            
            do {
                let result = try JSONDecoder().decode(LoginModel.self, from: data!)
                UserDefaults.standard.set(result.token, forKey: "token")
                DispatchQueue.main.async {
                    self.view.window?.rootViewController = ViewController()
                    self.view.window?.makeKeyAndVisible()
                    self.navigationController?.pushViewController(ViewController(), animated: true)
                }
            } catch {
                fatalError()
            }
        }
        task.resume()
    }
    
    private func configUI() {
        view.addSubview(card)
        view.addSubview(logo)
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
        ])
    }
}
