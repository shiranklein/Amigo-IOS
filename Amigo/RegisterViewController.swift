//
//  RegisterViewController.swift
//  Amigo
//
//  Created by Guy Peleg on 06/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol RegiserDelegate{
    func onComplete(success:Bool);
}

class RegisterViewController: UIViewController,UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,LoginViewControllerDelegate {
    func onLoginSuccess() {
    }
    
    func onLoginCancell() {
    }
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    
    
    func onComplete(success: Bool) {
        print("on Complete signInOut \(success)")
        if success == true {
            print("on Complete signInOut success")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "TabController")
            self.present(signInVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        self.activity.isHidden = false
        Auth.auth().createUser(withEmail: emailUser.text!, password: passwordUser.text!){ authResult, error in
            if let u = authResult {
                Model.instance.saveImage(image: self.imageViewAvatar.image!){ (url) in
                    if url != "" {
                        Model.instance.register(fullname: self.fullName.text!, email: self.emailUser.text!, pwd: self.passwordUser.text!,url: "url") { (success) in
                            if success {
                                let us = User(id:Auth.auth().currentUser!.uid);
                                us.email = self.emailUser.text!
                                us.ImagAvatr = url
                                us.fullname = self.fullName.text!
                                Model.instance.add(user: us)
                                us.addUserToDb()
                                Model.instance.logedIn = true
                                UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
                                UserDefaults.standard.synchronize()
                                self.activity.isHidden = true
                                let main = UIStoryboard(name:"Main", bundle: nil)
                                let home = main.instantiateViewController(identifier: "Home")
                                self.present(home, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        print("Fail")
                    }
                }
            }
            else {
                self.activity.isHidden = true
                let alert = UIAlertController(title: "Have Problem With Email or Password", message: "Try Again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func uploadPhotoBtn(_ sender: Any)
    {
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
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageViewAvatar.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.activity.isHidden = true
        imageViewAvatar.layer.borderWidth = 1
        imageViewAvatar.layer.masksToBounds = false
        imageViewAvatar.layer.borderColor = UIColor.black.cgColor
        imageViewAvatar.layer.cornerRadius = imageViewAvatar.frame.height/2
        imageViewAvatar.clipsToBounds = true
        view.backgroundColor = UIColor.black
        let layer = CAGradientLayer()
        let color1 = UIColor(red:0.99, green: 0.48, blue: 0.48, alpha: 1.0)
        let color2 = UIColor(red:0.65, green: 0.76, blue: 1.00, alpha: 1.0)
        
        layer.colors = [ color1.cgColor ,color2.cgColor]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        //Image Picker
        
    }
    
}


