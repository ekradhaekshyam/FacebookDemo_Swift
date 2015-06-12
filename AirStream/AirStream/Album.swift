//
//  Album.swift
//  AirStream
//
//  Created by Shyam Gosavi on 02/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumDelegate {
    func ablumSelectionChanged(sender:Album)
    func albumGotThumbnail(sender:Album)
}

struct AlbumFrame{
    var internalRect:CGRect;
    var image:UIImage;
}
/**    Frame and construction style.
*
* Road: For streets or trails.
* Touring: For long journeys.
* Cruiser: For casual trips around town.
* Hybrid: For general-purpose transportation.
*/
class Album {
    /**
    This is static method to get all video albums from facebook user account,
    Function use user shared instance and using userID FBSDKGraphRequest
    
    :param: 0
    
    :returns void
    */
    var aid:String = ""
    var name:String = ""
    var ellipsisName:String = ""
    var description:String = ""
    var modifiedDate:String = ""
    var owner:String = ""
    var pictureCount:Int = 0
    var cover_pid:String = ""
    var object_id:Int = 0
    var canUpload:Bool = true
    
    var coverImageURL:String = ""
    var coverImage:UIImage?
    
    var isSelected:Bool?
    var delegate:AlbumDelegate?
    
    
    /**
    Fill Album object with with dictionary
    
    @param dict will use to Album object
    
    @return void
    */
    
    func fillAlbum(dict:NSDictionary){
        if  dict.count > 0 {
        self.aid = dict.objectForKey("id") as! String// ["id"]
        self.name = dict.objectForKey("name") as! String
        self.ellipsisName = dict.objectForKey("name") as! String
        if  let descri: AnyObject = dict.objectForKey("description")
            {
                self.description = descri as! String
            }

        self.modifiedDate = dict.objectForKey("updated_time") as! String
        if let tempCount = dict.objectForKey("count")?.integerValue
        {
            self.pictureCount = tempCount // dict.objectForKey("count")?.integerValue
        }
        
            if let coverPid:String = dict.objectForKey("cover_photo") as? String {
                self.cover_pid = coverPid
            }
            
            if let cimageURL:String = dict.objectForKey("link") as? String{
                self.coverImageURL = cimageURL
            }
        }

    }
    
    func updateOnSelectChange()
    {
        if self.delegate != nil {
            self.delegate?.ablumSelectionChanged(self)
        }
    }
    
    
    func RetrieveImage(){
       RetrieveImageInThread()
    }
    
    
    func notifyDelegateOnCoverImageChange(){
        if self.delegate != nil {
            self.delegate?.albumGotThumbnail(self)
        }
    }
    
    
    func RetrieveImageInThread(){
          var graphRequest = FBSDKGraphRequest(graphPath: String("/\(self.cover_pid)"), parameters:nil, HTTPMethod: "GET")
                
                var error:NSError
                var result:NSObject
                var connection:FBSDKGraphRequestConnection
                graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
                    if result != nil {
                    if let imageUrl = result.valueForKey("source") as? String {
                    self.coverImageURL = imageUrl
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            let url = self.coverImageURL
                            let imageData = NSData(contentsOfURL: NSURL(string: url)!)
                            if  imageData != nil {
                                
                                self.coverImage = UIImage(data: imageData!)
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    // update some UI
                                    self.NotifyFromMainThread()
                                })
                            }
                        })
                    }
                    }
                }

    }
        
    func NotifyFromMainThread(){
        if self.delegate != nil {
            self.delegate?.albumGotThumbnail(self)
        }
    }
    

}