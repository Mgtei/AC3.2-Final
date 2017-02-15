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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        
        //checks if user is logged in
        if FIRAuth.auth()?.currentUser != nil {
            dump("CURRENT USER HEREEEEEEE \(FIRAuth.auth()!.currentUser!.uid)")
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                fetchUser(uid)
                self.currenUserId = uid
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(!animated)
        usernameTextField.setUpUnderlineLayer()
        passwordTextField.setUpUnderlineLayer()
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
    }




}

