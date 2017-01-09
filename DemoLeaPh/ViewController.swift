//
//  ViewController.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2016/12/20.
//  Copyright © 2016年 谷口健一郎. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire
import JAYSON

class ViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userIDField: UITextField!
    @IBOutlet weak var userEmailField: UITextField!
    
     let user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userNameField.placeholder = "ユーザー名を入力してください"
        userIDField.placeholder = "パスワードを入力してください(6文字以上)"
        userEmailField.placeholder = "Emailアドレスを入力してください"
                
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapRegist(_ sender: Any) {
        if (userNameField.text != "") && (userIDField.text != "") && (userEmailField.text != "")  {
            user.name = userNameField.text!
            user.userId = userIDField.text!
            user.email = userEmailField.text!
            
            uploadUserInfo()
            print("保存完了")
            let storyboard = self.storyboard
            let newRoot = storyboard?.instantiateViewController(withIdentifier: "Top") as! TopViewController
            UIApplication.shared.keyWindow?.rootViewController = newRoot
            
        }else{
        let alert = SCLAlertView()
        alert.showError("空欄項目があります", subTitle: "全て埋めてください")
        }

}
    
    func uploadUserInfo() {
       var parameters = [
        "user":[
        "name":userNameField.text! as String,
        "email":userEmailField.text! as String,
        "password":userIDField.text! as String
        ]
    ]
        print("送信")
        Alamofire.request("http://localhost:3000/users", method: .post, parameters: parameters).responseJSON(completionHandler: {response in
            
          let json = try! JAYSON(any: response.result.value)
            if json["user_id"] != nil {
            self.user.id = json["user_id"].int!
            self.user.save()
            }
        })
    }

}
