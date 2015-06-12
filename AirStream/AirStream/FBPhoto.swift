//
//  FBPhoto.swift
//  AirStream
//
//  Created by Shyam Gosavi on 10/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import Foundation

enum PhotoDownloadedState {
    case newEntry,
    downloadedComplete,
    failedwithError
}
/*
*  FBPhotoRecorf will be use for donwloading images 
*/
class FBPhotoRecord {
    let name:String
    let url:NSURL
    var state = PhotoDownloadedState.newEntry
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:NSURL) {
        self.name = name
        self.url = url
    }
}
class ImageDonwloadingPendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
    lazy var filtrationsInProgress = [NSIndexPath:NSOperation]()
    lazy var filtrationQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
}