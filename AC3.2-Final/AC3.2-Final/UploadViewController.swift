//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User?
    var post = [Post]()
    let picker = UIImagePickerController()
    var progressLabel: UILabel!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        view.setNeedsLayout()
        picker.delegate = self
        
        let doneButton = UIBarButtonItem()
        doneButton.title = "Done"
        doneButton.target = self
        doneButton.action = #selector(doneButtonPressed(sender:))
        navigationItem.rightBarButtonItem = doneButton
        
        view.backgroundColor = UIColor.white
    }

    //MARK: - Actions - Photo upload
    func doneButtonPressed(sender: UIBarButtonItem) {
        addPostToFB()
        print("Done button pressed")
    }

    func presentPic(sender: UITapGestureRecognizer) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.centerImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addPostToFB() {
        guard (FIRAuth.auth()?.currentUser) != nil else { return }
        let databaseRef = FIRDatabase.database().reference()
        let postRef = databaseRef.child("posts").childByAutoId()
        
        let storage = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
        //add new record to FB Database
        let imageStorageRef = storage.child("images/\(postRef.key)")
        
        let imageData = UIImageJPEGRepresentation(self.centerImageView.image!, 0.6)
        //adding image to FB Storage
        
        let metaData = FIRStorageMetadata()
        metaData.cacheControl = "public,max-age=300"
        metaData.contentType = "image/jpeg"
        
        _ = imageStorageRef.put(imageData!, metadata: metaData, completion: { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
        })
        
//        let uploadTask = imageStorageRef.put(imageData!, metadata: nil) { (metadata, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//                return
//            }
//            
//        }
//        uploadTask.resume()
        
        let post = Post(key: postRef.key, comment: commentTextField.text!)
        let postDict = ["comment" : post.comment]
        
        postRef.setValue(postDict, withCompletionBlock: { (error: Error?, reference: FIRDatabaseReference) in
            if error != nil {
                print("Error uploading Post to Database: \(error)")
            }
        })
        
        
    }
    
    // MARK: - Setup
    func setupViewHierarchy() {
        view.addSubview(centerImageView)
        view.addSubview(commentTextField)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //Center ImageView
        centerImageView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(self.view.snp.width)
            view.top.equalToSuperview().offset(5)
        })
        // Comment Text Field
        commentTextField.snp.makeConstraints({ (view) in
            view.width.equalTo(centerImageView.snp.width).multipliedBy(0.9)
            view.height.equalTo(150)
            view.top.equalTo(centerImageView.snp.bottom).offset(5)
            view.centerX.equalTo(centerImageView.snp.centerX)
        })
    }
    
    // MARK: - Lazy Init
    internal lazy var commentTextField: UITextView = {
        var textField = UITextView()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    internal lazy var centerImageView: UIImageView = {
        var imageView = UIImageView()
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(presentPic(sender:)))
        
        imageView.image = UIImage(named: "camera_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.gestureRecognizers = [tapGestures]
        
        return imageView
    }()
    
    internal lazy var upArrow: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = #imageLiteral(resourceName: "upload")
        barButtonItem.style = .plain
        barButtonItem.target = self
        barButtonItem.action = #selector(doneButtonPressed(sender:))
        return barButtonItem
    }()
    
    internal var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
}
