//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Marcos Oliveira on 2/3/15.
//  Copyright (c) 2015 Techbinding. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies: [NSDictionary]! = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.blackColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        moviesTableView.insertSubview(refreshControl!, atIndex:0)

        loadVideosFromAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = moviesTableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieCell
        
        var movie = movies[indexPath.row] as NSDictionary
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var url = movie.valueForKeyPath("posters.thumbnail") as String
        var nsurl = NSURL(string: url)
        var request = NSURLRequest(URL: nsurl!)
        
        cell.posterView.setImageWithURLRequest(request, placeholderImage: UIImage(named: "noimage"),
            success: {
                (request, response, image) -> Void in
                    cell.posterView.image = image
            }, failure: {
                (resquest, response, error) -> Void in
        })

        return cell
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        var indexPath = moviesTableView.indexPathForSelectedRow()!
        var vc = segue.destinationViewController as MovieDetailViewController
        vc.movie = movies[indexPath.row] as NSDictionary
        moviesTableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    // MARK: functions
    func loadVideosFromAPI() -> Void {
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=xujwyn465fjkmptsyjz2s8d5")
        var request = NSURLRequest(URL: url!)
        SVProgressHUD.setBackgroundColor(UIColor.grayColor())
        SVProgressHUD.showInfoWithStatus("Loading")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:  {
            (response, data, error) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil) as NSDictionary
            self.movies = responseDictionary["movies"] as [NSDictionary]
            self.moviesTableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    
    func refresh() -> Void {
        loadVideosFromAPI()
        refreshControl.endRefreshing()
    }
}
