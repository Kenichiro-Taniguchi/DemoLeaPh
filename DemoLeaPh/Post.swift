//
//  Post.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2016/12/22.
//  Copyright © 2016年 谷口健一郎. All rights reserved.
//

import Foundation

class Post: NSObject {
    var title:String = ""
    var userName:String = ""
    var imageUrl:NSURL?
    
    init(title:String,userName:String,imageUrl:NSURL?) {
        self.title = title
        self.userName = userName
        self.imageUrl = imageUrl
    }
    
}
