//
//  PhotosViewController.swift
//  AirStream
//
//  Created by Shyam Gosavi on 03/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import UIKit
/**
    This class  will Image scroll
*/
class PhotosViewController: UIViewController,FBhelperClassDelegate {
    var currentImageView:UIImageView?
    /// Url array object store all photos url from album
    var urlArray = [NSURL]()
    /// imagesViews array will store all image view objects.
    var imageViews = [UIImageView]()
    /// albumID will use for fetching photos from album
    var albumId:String = ""
    /// albumname will be use to set controller name
    var albumname:String = ""
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FacebookHelper.delegate = self
        ///Call photo list method of facebook helper
        FacebookHelper.getPhotoListfromAlbum(albumId)
        pageControl.currentPage = 0
        self.imageScrollView.pagingEnabled = true
        
        self.title = self.albumname
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
          /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    ///
    /// startDownloading download image from facebbok album
    ///
    /// :param url url of image
    /// :retrun void
    ///
    
    func startDownloading(url:NSURL){
        // TODO Add this code to NSopertion and this operation on queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let imageData = NSData(contentsOfURL:url)
            let image =  UIImage(data: imageData!)
            if  imageData != nil && image != nil {
                dispatch_sync(dispatch_get_main_queue(), {
                    // update some UI
                    self.currentImageView!.image = image
                    self.activityIndicator.hidden = true
                    self.activityIndicator.stopAnimating()
                    self.view.setNeedsDisplay()
                    
                })
            }
        })
    }

    ///Scrollview delegate
    func scrollViewDidEndDecelerating(scrollView:UIScrollView){
        let width = scrollView.frame.size.width;
        let page:Int = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        let imageView = imageViews[page] as UIImageView
        self.currentImageView = imageView
        if self.currentImageView!.image == nil {
            /// Show activity Indictor
            self.activityIndicator.startAnimating()
            self.activityIndicator.hidden = false
            // image is not downloaded so Download current index photo
            startDownloading(self.urlArray[page])
            //activity
           
        }
         self.pageControl.currentPage = page
    }
    
    ///Facebook helper delegate class
    
    func photoList(imageArray:[FBPhotoRecord]){
        pageControl.numberOfPages = imageArray.count
        
        var x:CGFloat = 0.0
        for index in imageArray {
            
            var tempimageView:UIImageView = UIImageView(frame: CGRectMake(x, 0.0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height))
            tempimageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.urlArray.append(index.url)
            self.imageScrollView.addSubview(tempimageView)
            self.imageViews.append(tempimageView)
            
            x += self.imageScrollView.frame.size.width + 1
        }
        let w:CGFloat = CGFloat(imageArray.count) * self.imageScrollView.frame.size.width
        self.imageScrollView.contentSize = CGSizeMake(w,self.imageScrollView.frame.height)
        self.currentImageView = self.imageViews[0]
        startDownloading(self.urlArray[0])
        self.pageControl.currentPage = 0
    }
    

    
}