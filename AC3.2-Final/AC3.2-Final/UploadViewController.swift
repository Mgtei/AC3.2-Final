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
    private let reuseId = "cellID"
    private let cellId = "cellId"
    var progressView: UIProgressView!
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
        //need to put in code to upload to FB here
        print("Done button pressed")
    }
    
    
    func presentPic() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.centerImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        //showBlackScreen()
        addPhotoToDB()
    }
    
//    func showBlackScreen() {
//        if let window = UIApplication.shared.keyWindow {
//            blackScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissProgressBar)))
//            
//            window.addSubview(blackScreen)
//            blackScreen.frame = window.frame
//            blackScreen.alpha = 0
//            
//            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                
//                self.blackScreen.alpha = 1
//                
//            }, completion: nil)
//            
//        }
//    }
    
    func dismissProgressBar() {
        self.coloredView.alpha = 1
    }
    
    
    
    func uploadButtonPressed() {
        //put in upload to Firebase code
        print("button pressed")
        presentPic()
    }
    
    func addPhotoToDB() {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        guard let postName = currentUser.displayName else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        //guard let imageTitle = photoTitletextField.text else { return }
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
        
        let key = ref.child("images").childByAutoId().key
        let imageRef = storage.child("images").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.centerImageView.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let pic: [String: Any] = [
                        "userID" : uid,
                        "pathToImage" : url.absoluteString,
                        //"imageTitle" : imageTitle,
                        "author" : postName,
                        "postID" : key]
                    
                    let postPic = ["\(key)" : pic]
                    
                    ref.child("uploads").updateChildValues(postPic)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        uploadTask.resume()
        
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
            view.width.equalTo(centerImageView.snp.width)
            view.height.equalTo(100)
            view.top.equalTo(centerImageView.snp.bottom).offset(5)
            view.centerX.equalTo(centerImageView.snp.centerX)
        })
    }
    
    // MARK: - Lazy Init
    internal lazy var commentTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Comment here"
        textField.attributedPlaceholder = NSAttributedString(string: "Comment", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
        return textField
    }()
    
    internal lazy var centerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "camera_icon")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    internal lazy var upArrow: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = #imageLiteral(resourceName: "upload")
        barButtonItem.style = .plain
        barButtonItem.target = self
        barButtonItem.action = #selector(uploadButtonPressed)
        return barButtonItem
    }()
    
    internal var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
}
