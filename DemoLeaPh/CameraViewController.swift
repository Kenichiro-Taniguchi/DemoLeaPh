//
//  CameraViewController.swift
//  DemoLeaPh
//
//  Created by 谷口健一郎 on 2016/12/23.
//  Copyright © 2016年 谷口健一郎. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import SCLAlertView
import CoreLocation
import RealmSwift
import JAYSON

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    
        
    var imageUrl:URL?
    var flag:Bool?
    var takePhotoImage:UIImage?
    var gps:Any?
    var locationManager:CLLocationManager?
    let postFile = PostFile()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let realm = try! Realm()
        
        let user = realm.objects(User).first
        postFile.user_id = (user?.id)!
        
        
               
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        postFile.latitude = newLocation.coordinate.latitude
        postFile.longitude = newLocation.coordinate.longitude
        
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        
        flag = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }

        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
           let cameraPicker = UIImagePickerController()
           cameraPicker.sourceType = sourceType
           cameraPicker.delegate = self
           self.present(cameraPicker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if flag == false {
       
        let assetUrl = info[UIImagePickerControllerReferenceURL] as! URL
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // PHAsset = Photo Library上の画像、ビデオ、ライブフォト用の型
        let result = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        
        let asset = result.firstObject
        
        // コンテンツ編集セッションを開始するためのアセットの要求
        asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            // contentEditingInput = 編集用のアセットに関する情報を提供するコンテナ
            let url = contentEditingInput?.fullSizeImageURL
            // 対象アセットのURLからCIImageを生成
            let inputImage = CIImage(contentsOf: url!)!
            // GPS
            self.gps = inputImage.properties["{GPS}"]
            
            if self.gps != nil {
                if ((pickedImage) != nil) {
                
                    self.imageSetUp(pickedImage: pickedImage!)
                    let obj = try! JAYSON(any: self.gps)
                    self.postFile.latitude = obj["Latitude"].double!
                    self.postFile.longitude = obj["Longitude"].double!
                    
                    
                    
                 
                }
                
                
                picker.dismiss(animated: true, completion: nil)
            }else{
                let alert = SCLAlertView()
                alert.showError("位置情報がありません", subTitle: "この写真は使えません")
                
            }

            
            
            })
            
        }else{
            if CLLocationManager.locationServicesEnabled() {
                locationManager?.stopUpdatingLocation()
            }
            
            let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            
            self.imageSetUp(pickedImage: pickedImage!)
            
            picker.dismiss(animated: true, completion: nil)
            
            
        
        }
        
        
        
        
       
    }
    
    
    func imageSetUp(pickedImage:UIImage){
        self.cameraView.contentMode = .scaleAspectFit
        self.cameraView.image = pickedImage
        
        let filemanager = FileManager.default
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpeg"
        
        let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
        
        filemanager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        if (filemanager.fileExists(atPath: filePath)){
            self.imageUrl = URL.init(fileURLWithPath: filePath) as URL
        }
    }
    
   

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showAlbum(_ sender: Any) {
        
        flag = false
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapPost(_ sender: Any) {
        
        
               postFile.title = titleText.text!
        
        
        postFile.postImage(fileURL: imageUrl!)
        
        dismiss(animated: true, completion: {
        
        })
        
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
