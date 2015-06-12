//
//  FacebookHelper.swift
//  AirStream
//
//  Created by Shyam Gosavi on 03/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import Foundation

@objc protocol FBhelperClassDelegate {
    optional func albumResult()
    optional func photoResult()
    optional func photoList(imageArray:[FBPhotoRecord])
}

class FacebookHelper {
    /// albumArray static class instatnce veriable to access from album data from anywhere
    static var albumArray = [Album]()
    /// delegate static class instatnce veriable to notifiy controller
    static var delegate:FBhelperClassDelegate?
    /// photos static class instatnce veriable to photos collection
    static var photos = [FBPhotoRecord]()
    
    /**
    This is static method to get all video albums from facebook user account,
    Function use user shared instance and using userID FBSDKGraphRequest
    
    :param: 0
    
    :returns void
    */
    static func getVideoAlbumList(){
        let userObject = User.sharedInstance()
        let userId = userObject.userDict["id"] as! String
        
        
        let fql:String = String("graph.facebook.com/")
        var param = [NSObject:AnyObject]()
        param["query"] = fql
        var graphRequest = FBSDKGraphRequest(graphPath: String("/\(userId)/videos"), parameters: param as [NSObject : AnyObject], HTTPMethod: "GET")
        var error:NSError
        var result:NSObject
        var connection:FBSDKGraphRequestConnection
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            //process video result
        }
    }
    
    /**
    This is static method to get all photo albums from facebook user account,
    Function use user shared instance and using userID FBSDKGraphRequest
    
    :param: 0
    
    :returns void
    */
    static func getPhotoAlbumList(){
        let userObject = User.sharedInstance()
        let userId = userObject.userDict["id"] as! String
        let fql:String = String("graph.facebook.com/")
        var param = [NSObject:AnyObject]()
        param["query"] = fql
        var graphRequest = FBSDKGraphRequest(graphPath: String("/\(userId)/albums"), parameters:nil, HTTPMethod: "GET")
        
        var error:NSError
        var result:NSObject
        var connection:FBSDKGraphRequestConnection
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            /// hadle result/Error
            if  error == nil{
                let resultArray:AnyObject? = result.valueForKey("data")
                if  resultArray != nil {
                    for var index = 0 ; index < resultArray!.count; index++ {
                        var album = Album()
                        var valueDict = resultArray![index] as? NSDictionary
                        album.fillAlbum(valueDict!)
                        self.albumArray.append(album)
                    }
                }
                //Send notification to Viewcontroller album data got
                self.delegate!.albumResult!()
                //ALbum list
                
            }
        }
    }
    /**
    This is static method to get all photos list from Album from facebook user,
    Function use user shared instance and using userID FBSDKGraphRequest
    
    :param: albumID String, selected albumID is use to get list of photo from that album
    
    :returns void
    */
    static func getPhotoListfromAlbum(albumID:String) {
        let userObject = User.sharedInstance()
        let userId = userObject.userDict["id"] as! String

        
        let fql:String = String("graph.facebook.com/")
        var param = [NSObject:AnyObject]()
        param["query"] = fql

        var graphRequest = FBSDKGraphRequest(graphPath: String("/\(albumID)/photos"), parameters:nil , HTTPMethod: "GET")
        
        var error:NSError
        var result:NSObject
        var connection:FBSDKGraphRequestConnection
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
           
            let resultArray = result.objectForKey("data") as! [AnyObject]
            var photoArray = [UIImage]()
            self.photos = [FBPhotoRecord]()
            let pendingoperttions = ImageDonwloadingPendingOperations()
            if  resultArray.count > 0 {
                for (index, value) in enumerate(resultArray) {
                    //add to operation
                    
                    let soruceURL = value.objectForKey("source") as! String
                    let imageDetails = FBPhotoRecord(name: "", url: NSURL(string: soruceURL)!)
                    self.photos.append(imageDetails)
                }
            }
            self.delegate?.photoList!(self.photos)
        }
    }
    
}
