//
//  PostCell.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2016/12/22.
//  Copyright © 2016年 谷口健一郎. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(post :Post){
      self.userNameLabel.text = post.userName
      self.titleLabel.text = post.title
      var imageData = NSData(contentsOf: post.imageUrl! as URL)
      self.postImage.image = UIImage(data: imageData as! Data)
    }
    @IBAction func tapImage(_ sender: Any) {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(postImage.image!)
        images.append(photo)
        
        let browser = SKPhotoBrowser(originImage: postImage.image!, photos: images, animatedFromView: postImage)
        browser.initializePageIndex(0)
        self.window?.rootViewController?.present(browser, animated: true, completion: nil)
    }

}
