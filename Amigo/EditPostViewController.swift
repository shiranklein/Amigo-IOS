//
//  EditPostViewController.swift
//  Amigo
//
//  Created by אביעד on 25/03/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD
import Kingfisher
class EditPostViewController: UIViewController {
    var data = [Post]()
    var post:Post?
    var postEditID = ""
    var imageUrl = ""
    var name = ""
    var city = ""
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var textOfRecommend: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : UIImage?
    
    @IBAction func uploadPhoto(_ sender: Any) {
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
    
    
    @IBAction func PodtEditButtom(_ sender: Any) {
        activity.isHidden = false
        let db : Firestore!
        db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let docId = document.documentID
                    if(self.postEditID == docId){
                        self.city = document.get("title") as! String
                        self.name = document.get("userName") as! String
                        Model.instance.saveImagePost(image: self.imageView.image!){ (url) in
                            if url != "" {
                                Model.instance.savePost(title: self.city, placeLocation: self.placeText.text!, userName:self.name, recText: self.textOfRecommend.text!, url: "url") { (success) in
                                    if success {
                                        // Model.instance.deleteAPosts(postIds: docId)
                                        print("toto")
                                        let po = Post(id: docId);
                                        po.title = self.city
                                        po.userName = self.name
                                        po.placeImage = url
                                        po.recText = self.textOfRecommend.text!
                                        po.placeLocation = self.placeText.text!
                                        po.userId = Auth.auth().currentUser!.uid
                                        po.postId = docId
                                        Model.instance.addPost(post: po)
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                }
                                
                            }
                            
                        }
                        break;
                    }
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        let layer = CAGradientLayer()
        let color1 = UIColor(red:0.99, green: 0.48, blue: 0.48, alpha: 1.0)
        let color2 = UIColor(red:0.65, green: 0.76, blue: 1.00, alpha: 1.0)
        
        layer.colors = [ color1.cgColor ,color2.cgColor]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        activity.isHidden = false;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        tapGesture.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        postEditID = Model.instance.postID
        let db : Firestore!
        db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let docId = document.documentID
                    if(self.postEditID == docId){
                        self.placeText.text = document.get("placeLocation") as! String
                        self.textOfRecommend.text = document.get("recText") as! String
                        self.imageUrl = document.get("placeImage") as! String
                        if (self.imageUrl != nil){
                            let url = URL(string: self.imageUrl)
                            let data = try? Data(contentsOf: url!)
                            self.imageView.image = UIImage(data: data!)
                        }
                        break;
                    }
                    
                }
                self.activity.isHidden = true;
            }
        }
    }
    
    
    @objc func handleSelectPhoto(){
        print("handle Select Photo")
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate //current vc
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension EditPostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking media")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


