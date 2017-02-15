//
//  ViewController.swift
//  AC3.2-Final
//
//  Created by Jason Gresh on 2/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let transition = CircularTransition()
    var currentUser: User?
    var currenUserId: String?
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        
        //checks if user is logged in
        if FIRAuth.auth()?.currentUser != nil {
            dump("CURRENT USER HERE \(FIRAuth.auth()!.currentUser!.uid)")
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                fetchUser(uid)
                //self.currentUserId = uid
            }
        }
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
    
    func fetchUser(_ uid: String) {
        let ref = FIRDatabase.database().reference()
        //let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(uid).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let uploads = snapshot.value as! [String: AnyObject]
            
            for (_,value) in uploads {
                //dump(value)
                if let name = value["name"] as? String {
                    let userName = User(name: name, email: "", password: "")
                    //self.currentUser = userName
                }
            }
        })
        ref.removeAllObservers()
    }
    
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
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                if (self.passwordTextField.text?.characters.count)! < 6 {
                    
                    let alertController = UIAlertController(title: "Error", message: "Be sure to enter the correct password", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    
                    let alertController = UIAlertController(title: "Unknown Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                //
                return
            }
            
            if user != nil {
                self.animator = UIDynamicAnimator(referenceView: self.view)
                self.gravity = UIGravityBehavior(items: [self.logo])
                self.animator.addBehavior(self.gravity)
                
//                let profileViewController =  ProfileViewController()
//                profileViewController.transitioningDelegate = self
//                profileViewController.modalPresentationStyle = .custom
//                
//                //segue this data
//                profileViewController.currentUserUid = self.currenUserId
//                //self.pushViewController(profileViewController, animated: true)
//                self.navigationController?.pushViewController(profileViewController, animated: true)
//                print("signed in")
                
            }
        })
        
    }
    
    
    internal func tappedRegisterButton(sender: UIButton) {
        
        let registerViewController = RegisterViewController()
        registerViewController.transitioningDelegate = self
        registerViewController.modalPresentationStyle = .custom
        
        self.navigationController?.pushViewController(registerViewController, animated: true)
        //self.present(registerViewController, animated: true, completion: nil)
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = registerButton.center
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = registerButton.center
        
        return transition
    }
    
    
    // MARK: - Lazy Init
    internal lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "meatly_logo")
        return imageView
    }()
    
    internal lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        //textField.textColor = EyeVoteColor.textIconColor
        textField.attributedPlaceholder = NSAttributedString(string: "USERNAME", attributes: [NSForegroundColorAttributeName : UIColor.black ])
        //textField.textColor = EyeVoteColor.textIconColor
        return textField
    }()
    
    internal lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSForegroundColorAttributeName : UIColor.black ])
        //textField.textColor = EyeVoteColor.textIconColor
        textField.isSecureTextEntry = true
        return textField
    }()
    
    internal lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOG IN", for: .normal)
       // button.setTitleColor(EyeVoteColor.textIconColor, for: .normal)
        //button.layer.borderColor = EyeVoteColor.textIconColor.cgColor
        button.layer.borderWidth = 0.8
        return button
    }()
    
    internal lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("REGISTER", for: .normal)
        //button.setTitleColor(EyeVoteColor.textIconColor, for: .normal)
        //button.layer.borderColor = EyeVoteColor.textIconColor.cgColor
        button.layer.borderWidth = 0.8
        return button
    }()
}
