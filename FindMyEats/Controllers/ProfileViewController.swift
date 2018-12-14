//
//  ProfileViewController.swift
//  FindMyEats
//
//  Created by Kathy Nguyen on 10/28/18.
//  Copyright © 2018 Kathy Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    var image: UIImage!
    var firstName: String!
    var lastName: String!
    var emailAddr: String!

    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageField.layer.cornerRadius = 50
        imageField.clipsToBounds = true
        
        let ref = Database.database().reference(fromURL: "https://findmyeats.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(userID!).observe(.value, with: { snapshot in
            let dict = snapshot.value as! [String: Any]
            self.firstName = dict["firstname"] as? String
            self.lastName = dict["lastname"] as? String
            self.emailAddr = dict["email"] as? String
            
            let storageRef = Storage.storage().reference(forURL: "gs://findmyeats.appspot.com").child("user_Image").child(userID!)
            
            storageRef.getData(maxSize: 5 * 1024 * 1024, completion: { metadata, err in
                if err != nil {
                    return
                }
                self.image = UIImage(data: metadata!)
                self.imageField.image = self.image
                self.firstLabel.text = self.firstName + " " + self.lastName
                self.emailLabel.text = self.emailAddr
            })
        })
        


        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout_onClick(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            let alert = UIAlertController(title: "Input Error", message: error as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
