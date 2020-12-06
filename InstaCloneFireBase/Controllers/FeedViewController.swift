//
//  FeedViewController.swift
//  InstaCloneFireBase
//
//  Created by Evrim Demir on 5.12.2020.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
    }
    
    
    // MARK: - get data from firestore
    func getDataFromFirestore() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                if snapshot?.isEmpty != true  && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        
                        if let postBy = document.get("postBy") as? String {
                            self.userEmailArray.append(postBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
    
                    }
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
    // MARK: - table View Delegate MEthods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.userEmailLabel.text  = userEmailArray[indexPath.row]
        
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        cell.commentLabel.text = userCommentArray[indexPath.row]
        
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))

        
        
        
        return cell
    }

}
