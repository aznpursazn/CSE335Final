//
//  CreateViewController.swift
//  FindMyEats
//
//  Created by Kathy Nguyen on 10/12/18.
//  Copyright © 2018 Kathy Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageSource: UISegmentedControl!
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageField: UIImageView!
    
    var selImage: UIImage?
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
        
        imageField.layer.cornerRadius = 50
        imageField.clipsToBounds = true
        
        //        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.handleSelectProfileView))
        //        imageField.addGestureRecognizer(tapGuesture)
        //        imageField.isUserInteractionEnabled = true
    }
    
    @IBAction func dismiss_onclick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        guard let fName = fNameTextField.text, !fName.isEmpty else {
            
            let alert = UIAlertController(title: "Data First Name Error", message: "Correct data input is required.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        guard let lName = lNameTextField.text, !lName.isEmpty else {
            let alert = UIAlertController(title: "Data Last Name Error", message: "Correct data input is required.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            let alert = UIAlertController(title: "Data Email Error", message: "Correct data input is required.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        guard let pass = passwordTextField.text, !pass.isEmpty else {
            let alert = UIAlertController(title: "Data Password Error", message: "Correct data input is required.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // let default image be a place-holder
        if self.selImage == nil {
            self.selImage = UIImage(named: "person-placeholder")
        }
        
        guard let userImg = self.selImage, let imageData = userImg.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (user: User?, error: Error?) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            let uId = user?.uid
            
            // storage class location root location of FB storage
            // TO FIX !!!
            let storageRef = Storage.storage().reference(forURL: "gs://findmyeats.appspot.com").child("user_Image").child(uId!)
            
            if let profileImg = self.selImage, let imageData = profileImg.jpegData(compressionQuality: 1.0) {
                
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    }
                    let userImageURL = metadata?.downloadURL()?.absoluteString
                    // https://www.youtube.com/watch?v=z0-ME5HYook
                    // video for reference point
                    
                    // location that ties to the firebase database
                    let ref = Database.database().reference()
                    
                    // database is in child
                    let uId = user?.uid
                    let usersReference = ref.child("users")
                    let newUserReference = usersReference.child(uId!)
                    // keep the password a secret!
                    newUserReference.setValue(["firstname": fName, "lastname": lName, "email": email, "userImage": userImageURL])
                    self.performSegue(withIdentifier: "signUptoTabbarVC", sender: nil)
                })
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSelectProfileView() {
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        selImage = selectedImage
        imageField.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upload(_ sender: Any) {
        if imageSource.selectedSegmentIndex == 0
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                present(picker,animated: true,completion: nil)
            } else {
                print("No camera")
            }
            
        }else{
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // textfield func for the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fNameTextField.resignFirstResponder()
        self.lNameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true;
    }
    
    // disappear keyboard when tap somehere else in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}


