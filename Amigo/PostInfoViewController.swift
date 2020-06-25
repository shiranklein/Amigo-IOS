//
//  PostInfoViewController.swift
//  Amigo
//
//  Created by אביעד on 09/03/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher
class PostInfoViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var recText: UITextView!
    @IBOutlet weak var postEdit: UIBarButtonItem!
    
    var id = Auth.auth().currentUser?.providerID
    var post:Post?
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        self.reloadPost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postEdit.isEnabled = false
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        view.backgroundColor = UIColor.black
        let layer = CAGradientLayer()
        let color1 = UIColor(red:0.99, green: 0.48, blue: 0.48, alpha: 1.0)
        let color2 = UIColor(red:0.65, green: 0.76, blue: 1.00, alpha: 1.0)
        
        layer.colors = [ color1.cgColor ,color2.cgColor]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
    }
    
    func reloadPost() {
        
        usernameLabel.text = post?.userName
        recText.text = post?.recText
        userImage.image = UIImage(named: "avatar")
        placeImage.image = UIImage(named: "avatar")
        //take the post id for the edit.
        Model.instance.postID = post!.postId
        if post?.placeImage != ""{
            placeImage.kf.setImage(with: URL(string: post!.placeImage));
        }
        if(post?.userId == Auth.auth().currentUser?.uid){
            postEdit.isEnabled = true
        }
        let storage = Storage.storage()
        print(Auth.auth().currentUser!.uid)
        let str = storage.reference().child(post!.userId).downloadURL(completion: { (url, error) in
            if error == nil {
                self.userImage.kf.setImage(with: url)
            }
        })
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
