//
//  ViewController.swift
//  InstaCloneFireBase
//
//  Created by Evrim Demir on 5.12.2020.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }


    @IBAction func signInClicked(_ sender: UIButton) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { [self] (authData, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: self)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
                makeAlert(titleInput: "Error", messageInput: "Username/Passwowrd?")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

