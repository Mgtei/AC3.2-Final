//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var user: User?
    var post = [Post]()
    let picker = UIImagePickerController()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        view.setNeedsLayout()
        setTextView()
        picker.delegate = self
        
        let doneButton = UIBarButtonItem()
        doneButton.title = "Done"
        doneButton.target = self
        doneButton.action = #selector(doneButtonPressed(sender:))
        navigationItem.rightBarButtonItem = doneButton
        
        view.backgroundColor = UIColor.white
    }
    
    func setTextView() {
        commentTextView.delegate = self
        commentTextView.text = "Add a description..."
        commentTextView.textColor = UIColor.lightGray
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.gray.cgColor
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
        
        let post = Post(key: postRef.key, comment: commentTextView.text!)
        let postDict = ["comment" : post.comment]
        
        postRef.setValue(postDict, withCompletionBlock: { (error: Error?, reference: FIRDatabaseReference) in
            if error != nil {
                print("Error uploading Post to Database: \(error)")
            }
            else {
                print(reference)
                self.showOKAlert(title: "Success!", message: "Photo Uploaded to Meatly Successfuly", completion: {
                })
            }
        })
    }
    
    //MARK: - TextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
               textView.textColor = UIColor.black
           }
      }

    func textViewDidEndEditing(_ textView: UITextView) {
       if textView.text.isEmpty {
            textView.text = "Add a description..."
                textView.textColor = UIColor.lightGray
            }
       }
    //MARK: - Helper Functions
    
    func showOKAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Setup
    func setupViewHierarchy() {
        view.addSubview(centerImageView)
        view.addSubview(commentTextView)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //Center ImageView
        centerImageView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(self.view.snp.width)
            view.top.equalToSuperview().offset(5)
        })
        // Comment Text View
        commentTextView.snp.makeConstraints({ (view) in
            view.width.equalTo(centerImageView.snp.width).multipliedBy(0.9)
            view.height.equalTo(150)
            view.top.equalTo(centerImageView.snp.bottom).offset(5)
            view.centerX.equalTo(centerImageView.snp.centerX)
        })
    }
    
    // MARK: - Lazy Init
    internal lazy var commentTextView: UITextView = {
        var textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.layer.cornerRadius = 5
        return textView
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
}
