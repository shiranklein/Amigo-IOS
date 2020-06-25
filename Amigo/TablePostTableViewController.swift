//
//  TablePostTableViewController.swift
//  Amigo
//
//  Created by אביעד on 21/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import UIKit
import Firebase

class TablePostTableViewController: UITableViewController {
    var loadingView: UIView = UIView()
    var container: UIView = UIView()
    @IBOutlet weak var recTitle: UINavigationItem!
    var flag = true
    var data = [Post]()
    var postid = String()
    
    func runTimer(){
        let timer = Timer(fire: Date(), interval: 5.0, repeats: true, block: { (Timer) in
            self.reloadData()
            DispatchQueue.main.async {
                self.reloadData()
                
            }
        })
        
        RunLoop.current.add(timer, forMode: .default)
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var db : Firestore!
        db = Firestore.firestore()
        
        //change the title of the page to the pin that pressed
        var city:String?
        db.collection("cities").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    city = document.get("title") as! String
                    self.recTitle.title = city
                }
            }
            
        }
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        ModelEvents.RefreshDataEvent.observe {
            if(self.flag){
                self.reloadData()
                self.flag = false
            }
        }
        ModelEvents.PostDataEvent.observe {
            self.refreshControl?.beginRefreshing()
            self.reloadData();
        }
        self.refreshControl?.beginRefreshing()
        reloadData();
        self.runTimer()
    }
    
    @IBAction func plusButtom(_ sender: Any) {
        if(Model.instance.logedIn == true){
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let memberDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "addPost") as! AddPostViewController
            self.navigationController?.pushViewController(memberDetailsViewController, animated:true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "Login")
            self.present(signInVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func reloadData(){
        Model.instance.getAllPosts{ (_data:[Post]?) in
            if (_data != nil) {
                self.data = _data!;
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        }
        
    }
    func deletePost(postId: String){
        print("get in to here")
        Model.instance.deleteAPosts(postIds: postId)
        //   Model.instance.deletePost(postId: postId)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostViewCell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostViewCell
        
        cell.contentView.backgroundColor = UIColor.init(displayP3Red: 0.80, green: 0.62, blue: 0.7, alpha: 1.0)
        var city = self.recTitle.title
        let st = data[indexPath.row]
        cell.Name.text = st.userName
        cell.PlaceLabel.text = st.placeLocation
        cell.ImageView.image = UIImage(named: "avatar")
        if st.placeImage != ""{
            cell.ImageView.kf.setImage(with: URL(string: st.placeImage));
        }
        cell.deletePost.isHidden = true
        if(Model.instance.logedIn==true){
            if(st.userId == Auth.auth().currentUser!.uid){
                cell.deletePost.isHidden = false
            }
        }
        ModelEvents.RefreshDataEvent.post()
        return cell
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(Model.instance.logedIn == true){
            if (segue.identifier == "PostInfoSegue"){
                let vc:PostInfoViewController = segue.destination as! PostInfoViewController
                vc.post = selected
            }
            
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "Login")
            self.present(signInVC, animated: true, completion: nil)
        }
    }
    
    var selected:Post?
    @IBAction func deleteButtom(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you'd like to delete this post", preferredStyle: .alert)
        
        // yes action
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
            self.selected = self.data[indexPath!.row]
            let db = Firestore.firestore()
            db.collection("posts").getDocuments { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in snapshot!.documents {
                        self.postid = document.get("postId") as! String
                        if(self.selected?.postId == self.postid){
                            db.collection("deleter").document("Post").setData(["idPost" : self.selected!.postId])
                            self.deletePost(postId: self.selected!.postId)
                            break;
                            
                        }
                    }
                    
                    
                }
                
            }
            
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Model.instance.logedIn == true){
            selected = data[indexPath.row]
            performSegue(withIdentifier: "PostInfoSegue", sender: self)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "Login")
            self.present(signInVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func backFromCancelLogin(segue:UIStoryboardSegue){
        
    }
}



