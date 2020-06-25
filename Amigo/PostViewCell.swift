//
//  PostViewCell.swift
//  Amigo
//
//  Created by אביעד on 08/03/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import Firebase

class PostViewCell: UITableViewCell {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var PlaceLabel: UILabel!
    @IBOutlet weak var deletePost: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageView.layer.borderWidth = 1
        ImageView.layer.masksToBounds = false
        ImageView.layer.borderColor = UIColor.black.cgColor
        ImageView.layer.cornerRadius = ImageView.frame.height/2
        ImageView.clipsToBounds = true
        activity.isHidden = true
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
