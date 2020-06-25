//
//  MyProfileViewController.swift
//  Amigo
//
//  Created by Guy Peleg on 06/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import Kingfisher

class MyProfileViewController: UIViewController, LoginViewControllerDelegate {
    func onLoginSuccess() {
    }
    
    func onLoginCancell() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Logout: UIButton!
    @IBOutlet weak var ImageProfile: UIImageView!
    @IBOutlet weak var Name: UILabel!
   
       
    
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        
        self.profile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profile()
        ImageProfile.layer.borderWidth = 1
        ImageProfile.layer.masksToBounds = false
        ImageProfile.layer.borderColor = UIColor.black.cgColor
        ImageProfile.layer.cornerRadius = ImageProfile.frame.height/2
        ImageProfile.clipsToBounds = true
        view.backgroundColor = UIColor.black
        let layer = CAGradientLayer()
        let color1 = UIColor(red:0.99, green: 0.48, blue: 0.48, alpha: 1.0)
        let color2 = UIColor(red:0.65, green: 0.76, blue: 1.00, alpha: 1.0)
        
        layer.colors = [ color1.cgColor ,color2.cgColor]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
    }
    
    func profile() {
        if (!Model.instance.isLoggedIn()){
            self.Logout.isHidden = true
            self.Login.isHidden = false
            
        }
        //-------user's photo-------//
        if(Model.instance.logedIn == true){
            self.Logout.isHidden = false
            self.Login.isHidden = true
            
            let id = Auth.auth().currentUser!.uid
            UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
            UserDefaults.standard.synchronize()
            let storage = Storage.storage()
            let str = storage.reference().child(id).downloadURL(completion: { (url, error) in
                if error == nil {
                    
                    self.ImageProfile.kf.setImage(with: url)
                }
            })
            //-------user's fullname-------//
            var db : Firestore!
            db = Firestore.firestore()
            let uid = Auth.auth().currentUser?.uid
            var name:String?
            db.collection("users").getDocuments { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in snapshot!.documents {
                        let docId = document.documentID
                        if(uid == docId){
                            name = document.get("fullname") as! String
                            self.Name.text = name
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    
    @IBAction func LoginButtom(_ sender: Any) {
        let loginVc = LoginViewController.factory();
        loginVc.delegate = self
        show(loginVc, sender: self)
    }
    
    
    @IBAction func LogoutButtom(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to logout?", preferredStyle: .alert)
        
        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            Model.instance.logedIn = false
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            UserDefaults.standard.removeObject(forKey: "user_uid_key")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "Home")
            self.present(signInVC, animated: true, completion: nil)
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func UplodaPhoto(_ sender: Any) {
          let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
                
                if(UIImagePickerController.isSourceTypeAvailable(.camera))
                {
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true, completion: nil)
                }
                else
                {
                    print("Camera not available")
                }
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            self.present(actionSheet, animated: true, completion: nil)
    }
    
    
 @objc func handleSelectPhoto(){
     print("handle Select Photo")
     let picker = UIImagePickerController()
    picker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate //current vc
     picker.sourceType = .photoLibrary
     picker.allowsEditing = true
     present(picker, animated: true, completion: nil)
 }
}
extension MyProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking media")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            Model.instance.saveImage(image: image){ (url) in
                                      if url != "" {
                                        self.ImageProfile.image = image
                        }
                                      else {
                                        print("fail to change photo")
                        }
                }
        
    }
        dismiss(animated: true, completion: nil)
}
}
