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
