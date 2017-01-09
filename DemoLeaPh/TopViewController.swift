//
//  TopViewController.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2016/12/21.
//  Copyright © 2016年 谷口健一郎. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import JAYSON
import SVProgressHUD

class TopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var objs:JAYSON?
    var tapIndex:Int?
    var mapView:MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show(withStatus: "読み込み中")
        
        Alamofire.request("http://localhost:3000/posts").responseJSON(completionHandler: {response in
          self.objs = try! JAYSON(any: response.result.value)
            for obj in (self.objs?.array)! {
                var p = Post(title: obj["title"].string!, userName: obj["user"]["name"].string!, imageUrl: NSURL(string:"http://localhost:3000" + obj["image_url"]["image_url"]["url"].string!))
               
                self.posts.append(p)
                
            }
         self.tableView.reloadData()
         SVProgressHUD.dismiss()
          
        })
        
        
        // Do any additional setup after loading the view.
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostCell = tableView.dequeueReusableCell(withIdentifier: "leafCell", for: indexPath) as! PostCell
        
        cell.setCell(post: posts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! MapViewController?
        mapView?.latitude = objs?[indexPath.row]["latitude"].double!
        mapView?.longitude = objs?[indexPath.row]["longitude"].double!
        present(mapView!, animated: true, completion: nil)

        
    }
    
    
    
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
