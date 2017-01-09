//
//  Upload.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2017/01/03.
//  Copyright © 2017年 谷口健一郎. All rights reserved.
//

import Foundation
import Alamofire

class PostFile :NSObject{
    var title = ""
    var user_id = 1
    var latitude:Double = 0
    var longitude:Double = 0
    
     func postImage(fileURL:URL){
        
        Alamofire.upload(multipartFormData: { multipartFormData in
           multipartFormData.append(fileURL, withName: "image_url")
            if let data = self.title.data(using: String.Encoding.utf8){
               multipartFormData.append(data, withName: "title")
            }
            if let data = String(self.user_id).data(using: String.Encoding.utf8){
               multipartFormData.append(data, withName: "user_id")
            }
            if let data = String(self.latitude).data(using: String.Encoding.utf8){
                multipartFormData.append(data, withName: "latitude")
            }
            if let data = String(self.longitude).data(using: String.Encoding.utf8){
                multipartFormData.append(data, withName: "longitude")
            }
            
        
        }, to: "http://localhost:3000/posts", encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }
}
