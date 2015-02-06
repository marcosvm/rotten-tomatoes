//
//  MovieDetailViewController.swift
//  Rotten Tomatoes
//
//  Created by Marcos Oliveira on 2/4/15.
//  Copyright (c) 2015 Techbinding. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: NSDictionary!

    
    @IBOutlet weak var movieView: UIImageView!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.title = movie["title"] as? String
        
        synopsisTextView.textContainerInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, synopsisTextView.frame.origin.y+synopsisTextView.frame.size.height)
      
        movieView.backgroundColor = UIColor.blackColor()
        
        
        synopsisTextView.text = movie["synopsis"] as String
        synopsisTextView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        synopsisTextView.textColor = UIColor.whiteColor()
        synopsisTextView.editable = false

        let posterURL = movie.valueForKeyPath("posters.original") as String
        loadImages(posterURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages(url: String) -> Void {
        let lowResURL = NSURL(string: url)
        let request = NSURLRequest(URL: lowResURL!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let placeHolderImage = UIImage(data: data)!

            self.fadein(self.movieView, image: placeHolderImage, duration: 1.5)

            let highResURL = url.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori", options: .LiteralSearch, range: nil)
            self.loadHighResImage(highResURL, placeHolderImage: placeHolderImage)
        }
    }
    
    func loadHighResImage(url: String, placeHolderImage: UIImage) {
        let url = NSURL(string: url)
        let request = NSURLRequest(URL: url!)
        
        movieView.setImageWithURLRequest(request, placeholderImage: placeHolderImage, success: {
            (request, response, image) -> Void in

            self.fadein(self.movieView, image: image, duration: 1.5)
            
            }, failure: nil)
    }

    func fadein(view: UIImageView, image: UIImage, duration: NSTimeInterval) -> Void {
        view.alpha = 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            view.alpha = 1.0
        })
        view.image = image
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
