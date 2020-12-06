//
//  SettingsViewController.swift
//  InstaCloneFireBase
//
//  Created by Evrim Demir on 5.12.2020.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
        try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: self)
        } catch {
            print(error)
        }
        
    }
}
