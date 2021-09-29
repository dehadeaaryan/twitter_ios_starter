//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Aaryan Dehade on 9/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let tweetRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        tweetRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl
    }
    
    
    
    @objc func loadTweets() {
        numberOfTweets = 20
        
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params as [String : Any], success: { (tweets : [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
        }, failure: { Error in
            print("Could not retreive tweets")
        })
    }
    
    func loadMoreTweets() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numberOfTweets]
        
        numberOfTweets += 20
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params as [String : Any], success: { (tweets : [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { Error in
            print("Could not retreive tweets")
        })
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let userName = user["name"] as! String?
        
        cell.userNameLabel.text = userName
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let tweet = tweetArray[indexPath.row]
        
        // Get the new view controller using segue.destination.
        let tweetDetailsViewController = segue.destination as! TweetDetailsViewController
        
        // Pass the selected object to the new view controller.
        tweetDetailsViewController.tweet = tweet as? [String : Any]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
