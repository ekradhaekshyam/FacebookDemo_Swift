//
//  AlbumView.swift
//  AirStream
//
//  Created by Shyam Gosavi on 02/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import Foundation

protocol AlbumViewDelegate {
    
    func albumViewSelectionChanged(sender:AlbumView);
}



class AlbumView : UIView,AlbumDelegate {
    var album : Album?
    var albumFrame : AlbumFrame?
    var delegate:AlbumViewDelegate?
    var albumNameWithPicsCount:String?
    var isThumbnailGenerated:Bool?;
    var frameArray = [AlbumFrame]()
    var flag:Int = 0
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
//    convenience override init () {
//        self.init(frame:CGRectZero)
//    }


    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func addBehavior (){
        println("")
    }
    
    func getSize() -> (CGSize){
        return CGSizeMake(110, 110);
    }
//
//    
//    
//    func updateOnAlbumChange()
//    {
//        if album != nil {
//            isThumbnailGenerated = false;
//            album?.delegate! = self // apply delegate method
//    
//            if album!.coverImage != nil {
//            
//            }
//            
//        }
//        self.albumNameWithPicsCount = " \(album!.ellipsisName) ,\(album!.pictureCount)"
//        setNeedsDisplay()
//    }
//    
//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        if  album != nil {
//            album?.isSelected = false
//        }
//        else{
//            album?.isSelected = true
//        }
//        album?.updateOnSelectChange()
//        self.delegate?.albumViewSelectionChanged(self)
//    }
//    
    ///delegate method
    func ablumSelectionChanged(sender:Album) -> (Void){
        setNeedsDisplay()
    }
    func albumGotThumbnail(sender:Album){
        if sender.coverImage != nil {
            //change frame
        }
        isThumbnailGenerated = true
//        sender.coverImage = sender.coverImage?.resizedImageWithContentMode(contentMode: UIViewContentMode.ScaleAspectFit, bounds: albumFrame.internalRect.size, interpolationQuality: CGInterpolationQuality.kCGInterpolationDefault)
        setNeedsDisplay()
    }
    
}