//
//  RegisterViewController.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        configureConstraints()
        
    }
    
    
    // MARK: - Setup
    func setupViewHierarchy() {
        self.view.addSubview(name)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(registerButton)
        self.view.addSubview(logo)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        // Logo
        logo.snp.makeConstraints({ (view) in
            view.centerX.equalTo(self.view)
            view.width.height.equalTo(150)
            view.top.equalToSuperview().offset(10)
        })
        
        // UserName TextField
        name.snp.makeConstraints({ (view) in
            view.top.equalTo(logo.snp.bottom).offset(40)
            view.centerX.equalTo(self.view)
            view.width.equalToSuperview().multipliedBy(0.8)
            view.height.equalTo(44)
        })
        
        //Password TextField
        emailTextField.snp.makeConstraints({ (view) in
            view.top.equalTo(name.snp.bottom).offset(20)
            view.centerX.equalTo(self.view)
            view.width.equalTo(name.snp.width)
            view.height.equalTo(44)
        })
        
        // Login Button
        passwordTextField.snp.makeConstraints({ (view) in
            view.top.equalTo(emailTextField.snp.bottom).offset(20)
            view.centerX.equalTo(self.view)
            view.width.equalTo(emailTextField.snp.width)
            view.height.equalTo(44)
        })
        
        // Register Button
        registerButton.snp.makeConstraints({ (view) in
            view.bottom.equalTo(self.view.snp.bottom).inset(20)
            view.width.equalTo(270)
            view.height.equalTo(44)
            view.centerX.equalTo(self.view.snp.centerX)
        })
    }
    
        func gesturesAndControl() {
            registerButton.addTarget(self, action: #selector(tappedRegisterButton(sender:)), for: .touchUpInside)
        }
    
    //MARK: - Setup user data
       internal func tappedRegisterButton(sender: UIButton) {
        print("Register pressed")
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("cannot validate username/password")
            return
        }
        
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print("error adding user \(error)")
                
                // Error Messages
                if !(self.emailTextField.text?.contains("@"))!{
                    let alertController = UIAlertController(title: "Error: \(error)", message: "Make sure you enter a usable email address.", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                if self.name.text?.characters.count == 0 {
                    let nameAlertController = UIAlertController(title: "Error", message: "Please enter a name.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    nameAlertController.addAction(defaultAction)
                    self.present(nameAlertController, animated: true, completion: nil)
                    
                }
                
                if !(self.emailTextField.text?.contains("@"))!{
                    let alertController = UIAlertController(title: "Error", message: "Please enter a usable email address.", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    
                    let alertController = UIAlertController(title: "Unknown Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                    //
                }
                
                
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
//            let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
//            changeRequest.displayName = self.name.text!
//            changeRequest.commitChanges(completion: nil)
            
            //successfully authenticated user
//            let imageName = NSUUID().uuidString
            //let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
//            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
//                
//                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
//                    
//                    if error != nil {
//                        print(error!.localizedDescription)
//                        return
//                    }
//                    
//                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                        
//                        let values = ["name": name, "email": email]
//                        
//                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
//                    }
//                })
//            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://ac-32-final.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    // MARK: - Lazy Init
    internal lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "meatly_logo")
        return imageView
    }()
    
    //MARK: - Lazy vars
    
    internal lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(tappedRegisterButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    internal lazy var name: UITextField = {
        let textField = UITextField()
        
        textField.textColor = UIColor.lightGray
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
        
        return textField
    }()
    
    internal lazy var emailTextField: UITextField = {
        let textField = UITextField()
        
        textField.textColor = UIColor.lightGray
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
        
        return textField
    }()
    
    internal lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
   
        return textField
    }()
}
