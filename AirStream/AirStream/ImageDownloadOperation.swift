//
//  ImageDownloadOperation.swift
//  AirStream
//
//  Created by Shyam Gosavi on 10/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import Foundation

class Donwloader : NSOperation {
    let facebookImage:FBPhotoRecord
    
    
    //2
    init(facebookimage: FBPhotoRecord) {
        self.facebookImage = facebookimage
    }
    
    //3
    override func main() {
        //4
        if self.cancelled {
            return
        }
        //5
        let imageData = NSData(contentsOfURL:self.facebookImage.url)
        
        //6
        if self.cancelled {
            return
        }
        
        //7
        if imageData?.length > 0 {
            self.facebookImage.image = UIImage(data:imageData!)
            self.facebookImage.state = .downloadedComplete
        }
        else
        {
            self.facebookImage.state = .failedwithError
            self.facebookImage.image = UIImage(named: "Failed")
        }
    }
}