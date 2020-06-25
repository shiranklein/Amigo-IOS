//
//  Person.swift
//  Amigo
//
//  Created by אביעד on 09/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//


import Foundation

class Person: NSObject {
   var name: String
   var avatar: UIImage
   var wishList = [String]()
   var location: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
   
}
