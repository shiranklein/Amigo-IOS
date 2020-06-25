//
//  PhotoCollectionViewCell.swift
//  Amigo
//
//  Created by אביעד on 22/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
//    var delegate: PhotoCollectionViewCellDelegate?
//
    var post : PostUser?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        if let photoUrlString = post?.photoUrl{
            //let photoUrl = URL(string: photoUrlString)
            Model.instance.getImage(url: photoUrlString) { (uiimage : UIImage?) in
                self.photo.image = uiimage
            }
            //self.photo.sd_setImage(with: photoUrl, completed: nil)
        }
    }
    
 
    
}
