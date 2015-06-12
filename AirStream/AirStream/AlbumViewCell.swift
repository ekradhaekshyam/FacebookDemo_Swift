//
//  AlbumViewCell.swift
//  AirStream
//
//  Created by Shyam Gosavi on 03/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import UIKit

protocol AlbumCellDelegate {
    func seletedAlbum(index:Int)
    func assignCoverImage(album:Album,index:Int)
}

class AlbumViewCell: UICollectionViewCell,AlbumDelegate {

    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var verticalImageView: UIImageView!
    @IBOutlet weak var horizentalView: UIView!
    @IBOutlet weak var horizentalImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var delegate:AlbumCellDelegate? = nil
    var cellIndex:Int = 0
    var album:Album?
    
    func loadImage(){
        if album != nil {
            album!.RetrieveImageInThread()
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func albumViewSelected(sender: AnyObject) {
        if  self.delegate != nil {
            self.delegate!.seletedAlbum(cellIndex)
        }
    }
    
    func ablumSelectionChanged(sender: Album) {
        
       
    }
    func albumGotThumbnail(sender:Album){
        self.assigncoverImage(sender)
                if self.delegate != nil {
            self.delegate?.assignCoverImage(self.album!, index: self.cellIndex)
        }
    }
    
    func assigncoverImage(tempalbum:Album){
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()

        if tempalbum.coverImage!.size.width > tempalbum.coverImage!.size.height
        {
            self.verticalView.hidden = false
            self.verticalImageView.image = tempalbum.coverImage
        }
        else{
            self.horizentalView.hidden = false
            self.horizentalImageView.image = tempalbum.coverImage
        }

    }
    

}
