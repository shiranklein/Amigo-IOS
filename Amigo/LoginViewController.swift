//
//  LoginViewController.swift
//  Amigo
//
//  Created by Guy Peleg on 06/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

protocol LoginViewControllerDelegate {
    func onLoginSuccess();
    func onLoginCancell();
}

class LoginViewController: UIViewController,RegiserDelegate {
    
    var delegate:LoginViewControllerDelegate?
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Login")
    }
    
    @IBAction func CancelButtom(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onComplete(success: Bool) {
        print("on Complete signInOut \(success)")
        if success == true {
            print("on Complete signInOut success")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "Home")
            self.present(signInVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func Connect(_ sender: Any) {
        self.activity.isHidden = false
        Auth.auth().signIn(withEmail: email.text!, password: password.text!,completion: { (authResult,error) in
            if ((authResult) != nil){
                Model.instance.logedIn = true
                self.activity.isHidden = true
                self.dismiss(animated: true, completion: nil)
                if let delegate = self.delegate{
                    delegate.onLoginSuccess()
                }
                UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
                UserDefaults.standard.synchronize()
            }
            else{
                self.activity.isHidden = true
                let alert = UIAlertController(title: "Incorrect Username or Password", message: "Try Again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.isHidden = true
        view.backgroundColor = UIColor.black
        let layer = CAGradientLayer()
        let color1 = UIColor(red:0.99, green: 0.48, blue: 0.48, alpha: 1.0)
        let color2 = UIColor(red:0.65, green: 0.76, blue: 1.00, alpha: 1.0)
        
        layer.colors = [ color1.cgColor ,color2.cgColor]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
        
        if let delegate = delegate{
            delegate.onLoginCancell()
        }
    }
}
