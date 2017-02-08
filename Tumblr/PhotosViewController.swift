//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Palak Jadav on 2/7/17.
//  Copyright © 2017 flounderware. All rights reserved.
//
import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [NSDictionary] = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var offsetIncrement = 21
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        self.loadData()
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.loadData()
        refreshControl.endRefreshing()
    }
    func loadData()
    {
        
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(offsetIncrement)")
        

        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                self.isMoreDataLoading = false
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        let newData = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.posts = self.posts + newData
                        self.loadingMoreView!.stopAnimating()

                        self.tableView.reloadData()
                        self.offsetIncrement += 20
                    }
                }
        });

        task.resume()

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadData()
            }
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let post = posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url" as! String)
            if let imageUrl = URL(string: imageUrlString as! String) {
                cell.photoImageView.setImageWith(imageUrl)
            }
            else {
            }
        }
        else {
        }
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let post = posts[indexPath!.row]
        let photo = post.value(forKeyPath: "photos") as? [NSDictionary]
        let photosDetailViewController = segue.destination as! PhotoDetailsViewController
        photosDetailViewController.photos = photo
        
 
    }
    

}
