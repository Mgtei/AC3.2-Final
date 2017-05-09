//
//  ViewController.swift
//  AC3.2-Final
//
//  Created by Jason Gresh on 2/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//commit and clean up, progress fwd

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var currentUser: User?
    var currentUserId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViewHierarchy()
        configureConstraints()
        buttonFunctions()
    }
    
    
    // MARK: - Setup
    func setupViewHierarchy() {
        self.view.addSubview(logo)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
    }
    
    private func configureConstraints(){
        self.edgesForExtendedLayout = []
        
        // Logo
        logo.snp.makeConstraints({ (view) in
            view.centerX.equalTo(self.view)
            view.width.height.equalTo(150)
            view.top.equalToSuperview().offset(10)
        })
        
        // UserName TextField
        usernameTextField.snp.makeConstraints({ (view) in
            view.top.equalTo(logo.snp.bottom).offset(40)
            view.centerX.equalTo(self.view)
            view.width.equalToSuperview().multipliedBy(0.8)
            view.height.equalTo(44)
        })
        
        //Password TextField
        passwordTextField.snp.makeConstraints({ (view) in
            view.top.equalTo(usernameTextField.snp.bottom).offset(20)
            view.centerX.equalTo(self.view)
            view.width.equalTo(usernameTextField.snp.width)
            view.height.equalTo(44)
        })
        
        // Login Button
        loginButton.snp.makeConstraints({ (view) in
            view.bottom.equalTo(self.view.snp.bottom).inset(75)
            view.width.equalTo(200)
            view.height.equalTo(44)
            view.centerX.equalTo(self.view.snp.centerX)
        })
        
        // Register Button
        registerButton.snp.makeConstraints({ (view) in
            view.bottom.equalTo(self.view.snp.bottom).inset(20)
            view.width.equalTo(200)
            view.height.equalTo(44)
            view.centerX.equalTo(self.view.snp.centerX)
        })
    }
    
    // MARK: - Actions register/login user
    
    func buttonFunctions() {
        registerButton.addTarget(self, action: #selector(tappedRegisterButton(sender:)), for: .touchUpInside)
        
        loginButton.addTarget(self, action: #selector(tappedLoginButton(sender:)), for: .touchUpInside)
    }
    
    internal func tappedLoginButton(sender: UIButton) {
        
        guard let userName = usernameTextField.text, let password = passwordTextField.text else {
            print("cannot validate username/password")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: userName, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                
                //
                if self.usernameTextField.text?.characters.count == 0 {
                    let alertController = UIAlertController(title: "Error", message: "Don't forget to enter your name.", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler:{ (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                if (self.passwordTextField.text?.characters.count)! < 6 {
                    
                    let alertController = UIAlertController(title: "Error", message: "Be sure to enter the correct password", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    
                    let alertController = UIAlertController(title: "Unknown Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                //
                return
            } else {
                let alertController = UIAlertController(title: "Success", message: "Log In Successful", preferredStyle: .alert)
                let defautAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(defautAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
    }
    
    internal func tappedRegisterButton(sender: UIButton) {
        guard let email = usernameTextField.text,
            let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                let alertController = UIAlertController(title: "Registered", message: "Registration Successful!", preferredStyle: .alert)
                let defautAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(defautAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "Error, please try again.", preferredStyle: .alert)
                let defautAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(defautAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
    }
    
    // MARK: - Lazy Init
    internal lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "meatly_logo")
        return imageView
    }()
    
    internal lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username/Email", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.lightGray
        return textField
    }()
    
    internal lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.lightGray
        textField.isSecureTextEntry = true
        return textField
    }()
    
    internal lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.8
        return button
    }()
    
    internal lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.8
        return button
    }()
}
