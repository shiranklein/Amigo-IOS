//
//  ViewController.swift
//  Amigo
//
//  Created by Shiran Klein on 30/12/2019.
//  Copyright © 2019 Shiran Klein. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        let layer = CAGradientLayer()
        let color1 = UIColor(red:0.99, green: 0.48, blue: 0.48, alpha: 1.0)
        let color2 = UIColor(red:0.65, green: 0.76, blue: 1.00, alpha: 1.0)
        
        layer.colors = [ color1.cgColor ,color2.cgColor]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        // Check if the user is logged in
        if UserDefaults.standard.object(forKey: "user_uid_key") != nil {
            // send them to a new view controller or do whatever you want
            Model.instance.logedIn = true
        }
        else {
            Model.instance.logedIn = false
        }
        
    }
}

