//
//  GalleryViewController.swift
//  AC3.2-Final
//
//  Created by Margaret Ikeda on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class GalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [Post]()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        populatePosts()
        //if the user's not logged in we present the login view controller
        //if succeed then it will dissmiss itselff
        
        //checks if user is logged in
        if FIRAuth.auth()?.currentUser == nil {
            let vc = ViewController()
            present(vc, animated: true, completion: nil)
        }
    let logoutButton = UIBarButtonItem()
        logoutButton.title = "Log Out"
        logoutButton.target = self
        logoutButton.action = #selector(logoutButtonPressed(sender:))
        navigationItem.rightBarButtonItem = logoutButton
    
    }
    
    func logoutButtonPressed(sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch {
            print(error)
        }
        let vc = ViewController()
        self.present(vc, animated: true, completion: nil)
        return
    }
    
//        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
//            self.populatePosts()
//        })
//    }
    
    //}
    
    
    //MARK: - Download images from firebase
    //    func fetchPhotos(_ category: String) {
    //        let ref = FIRDatabase.database().reference()
    //        ref.child("Categories").child(category).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
    //            let categories = snapshot.value as! [String: AnyObject]
    //
    //            for (_,value) in categories {
    //
    //                if let photoUrl = value["pathToImage"] as? String,
    //                    let category = value["category"] as? String {
    //                    let photo = Photo(photoURL: photoUrl, category: category)
    //                    self.photos.append(photo)
    //                }
    //            }
    //            self.categoryTableView.reloadData()
    //
    //        })
    //        ref.removeAllObservers()
    //    }
    
    func populatePosts() {
        let ref = FIRDatabase.database().reference()
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let posts = snapshot.value as? [String: AnyObject] {
                
                for (key,value) in posts {
                    
                    if let comment = value["comment"] as? String {
                        let post = Post(key: key, comment: comment)
                        self.posts.append(post)
                    }
                    
                }
                self.categoryTableView.reloadData()
            }
        })
    }
    
    
    
    // MARK: - Setup
    func setupViewHierarchy(){
        view.addSubview(categoryTableView)
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GalleryTableViewCell
        let post = self.posts[indexPath.row]
        
        cell.commentLabel.text = post.comment
        cell.commentLabel.numberOfLines = 0

        
        let storage = FIRStorage.storage()
        cell.postImageView.image = nil
        // Create a storage reference from our storage service
        let storageRef = storage.reference()//forURL: "gs://barebonesfirebase-6883d.appspot.com/")
        let spaceRef = storageRef.child("images/\(post.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                cell.postImageView.image = image
            }
        }
        return cell
    }
    
    
    //    //navigationController?.pushViewController(galleryCollectionView, animated: true)
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let selectedRow = indexPath.row
    //        self.category = categories[selectedRow]
    //        let galleryCollectionView = GalleryCollectionViewController()
    //        galleryCollectionView.categorySelected = categories[selectedRow]
    //
    //        navigationController?.pushViewController(galleryCollectionView, animated: true)
    //    }
    //
    
    // MARK: - Lazy TableView
    internal lazy var categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
}
