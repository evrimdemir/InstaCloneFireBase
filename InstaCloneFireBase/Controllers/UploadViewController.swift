//
//  UploadViewController.swift
//  InstaCloneFireBase
//
//  Created by Evrim Demir on 5.12.2020.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    
    
    // MARK: - Select Image From Photo Library
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
//        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    
    // MARK: - Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Craete Alert Function
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: "", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Upload button Tapped
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            
                            // MARK: - Setting FireStore Database
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference: DocumentReference? = nil
                            
                            let fireStorePost = ["imageURL" : imageUrl!, "postBy" : Auth.auth().currentUser!.email, "postComment": self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes" : 0 ] as [String : Any]
                            
                            
                           
                                                            
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: fireStorePost, completion: { (error) in
                                if error != nil {
                                    
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    self.imageView.image = UIImage(named: "uploadImage")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
            
            
        }
        
    }
}
