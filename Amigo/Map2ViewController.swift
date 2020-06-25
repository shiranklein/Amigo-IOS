//
//  Map2ViewController.swift
//  Amigo
//
//  Created by אביעד on 09/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit

class Map2ViewController: UIViewController {

    @IBOutlet var MapView: UIView!
    
    let singletonInstance = Map2ViewController()

    private let kPeopleWishListManagerNumberOfPeople = 21

    class PeopleWishListManager: NSObject {
      // shared instance of PeopleWishListManager.
      class var sharedInstance: Map2ViewController { return singletonInstance }
     
      // people wishlist
      var people = [Person]()
     
      // MARK: - init
      override init() {
        super.init()
        populatePeopleList()
      }

      func populatePeopleList() {
        let names = ["Oren Nimmons", "Flor Addington", "Bernadette Bachus", ...]
     
        let coordinates = [CLLocationCoordinate2D(latitude: 47.57273, longitude: -52.68997)...]
     
        people = []
        for i in 0..<kPeopleWishListManagerNumberOfPeople {
          let wishlist = giveMeAWishList()
          let name = names[i]
          let avatar = UIImage(named: "avatar\(i+1)")!
     
          let person = Person(name: name, avatar: avatar)
          person.wishList = wishlist
          person.location = coordinates[i]
          people.append(person)
       }
     }
     
     func giveMeAWishList() -> [String] {
       let items = ["Watch", "Purple pen",..., "bottle of perfume"]
     
       let num = arc4random_uniform(3) + 1
       var wishlist = [String]()
       for _ in 0..<num {
          let index = Int(arc4random_uniform(UInt32(items.count)))
          wishlist.append(items[index])
       }
       return wishlist
      }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
