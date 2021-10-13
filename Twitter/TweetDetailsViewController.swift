//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Aaryan Dehade on 9/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import WebKit

class TweetDetailsViewController: UIViewController, WKUIDelegate {

    @IBOutlet var tweetWebView: WKWebView!
    
    var tweet: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let tweetEntities = tweet["entities"] as? [String: Any]
//        let tweetUrls = tweetEntities?["urls"] as? [[String: Any]]
//        let tweetUrls2 = tweetUrls?[0] as? [String: Any]
//        let tweetUrl = tweetUrls2?["url"] as! String
//        let url = tweetUrl
//        let URL = URL(string:"\(url)")
//        let request = URLRequest(url: URL!)
//        self.tweetWebView.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            tweetWebView = WKWebView(frame: .zero, configuration: webConfiguration)
            tweetWebView.uiDelegate = self
            view = tweetWebView
        }

}
