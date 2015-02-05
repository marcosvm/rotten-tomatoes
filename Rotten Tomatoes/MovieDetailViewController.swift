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
      
        
        synopsisTextView.text = movie["synopsis"] as String
        synopsisTextView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        synopsisTextView.textColor = UIColor.whiteColor()
        synopsisTextView.editable = false
                
        let posterURL = movie.valueForKeyPath("posters.original") as String
        let highRes = posterURL.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori", options: .LiteralSearch, range: nil)
        let url = NSURL(string: highRes)
        movieView.setImageWithURL(url)
        
        
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

}
