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
        navigationItem.rightBarButtonItem = upArrow
    }

    //MARK: - Actions - Photo upload
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
    
    func showBlackScreen() {
        if let window = UIApplication.shared.keyWindow {
            blackScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissProgressBar)))
            
            window.addSubview(blackScreen)
            blackScreen.frame = window.frame
            blackScreen.alpha = 0
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackScreen.alpha = 1
                
            }, completion: nil)
            
        }
    }
    
    func dismissProgressBar() {
        self.blackScreen.alpha = 0
    }
    
    
    
    func uploadButtonPressed() {
        
        print("button pressed")
        presentPic()
    }
    
    func addPhotoToDB() {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        guard let postName = currentUser.displayName else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let imageTitle = photoTitletextField.text else { return }
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
                        "imageTitle" : imageTitle,
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
        view.addSubview(containerView)
        view.addSubview(centerImageView)
        view.addSubview(uploadsCollectionView)
        containerView.addSubview(buttonCategoriesCollectionView)
        containerView.addSubview(photoTitletextField)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //ContainerView
        containerView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(75)
            view.top.equalToSuperview()
        })
        
        // Photo Title Text Field
        photoTitletextField.snp.makeConstraints({ (view) in
            view.width.equalTo(containerView.snp.width).multipliedBy(0.8)
            view.height.equalTo(30)
            view.top.equalTo(containerView.snp.top).offset(5)
            view.centerX.equalTo(containerView.snp.centerX)
        })
//        // CollectionView
//        buttonCategoriesCollectionView.snp.makeConstraints({ (view) in
//            view.bottom.equalTo(containerView.snp.bottom)
//            view.leading.equalTo(containerView.snp.leading)
//            view.trailing.equalTo(containerView.snp.trailing)
//            view.top.equalTo(photoTitletextField.snp.bottom)
//            
//            buttonCategoriesCollectionView.delegate = self
//            buttonCategoriesCollectionView.dataSource = self
//            buttonCategoriesCollectionView.register(CategoriesUploadCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
//        })
        
        uploadsCollectionView.snp.makeConstraints ({ (view) in
            view.top.equalTo(centerImageView.snp.bottom)
            view.width.equalToSuperview()
            view.bottom.equalToSuperview()
            
        })
        
        //Center ImageView
        centerImageView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(self.view.snp.width)
            view.top.equalTo(containerView.snp.bottom)
        })
        
    }
    //  copy and pasted from LoginView. Get code working
    // MARK: - CollectionView
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        if collectionView == buttonCategoriesCollectionView {
//            let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoriesUploadCollectionViewCell
//            buttonCell.backgroundColor = UIColor.white
//            let category = categories[indexPath.row]
//            buttonCell.categoriesLabel.text = category
//            return buttonCell
//        } else {
//            let uploadCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UploadCollectionViewCell
//            uploadCell.uploadImage.image = #imageLiteral(resourceName: "upload")
//            return uploadCell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: view.frame.width/5, height: 30)
//    }
    
    
    // MARK: - Lazy Init
    internal lazy var photoTitletextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Title"
        textField.attributedPlaceholder = NSAttributedString(string: "TITLE", attributes: [NSForegroundColorAttributeName : UIColor.darkGray ])
        return textField
    }()
    
    internal lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    internal lazy var centerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "Selfie10")
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
    
    
    internal lazy var buttonCategoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    internal lazy var uploadsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    internal var blackScreen: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    internal var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
}
