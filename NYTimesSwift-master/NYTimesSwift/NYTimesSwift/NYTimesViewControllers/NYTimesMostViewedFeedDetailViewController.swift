//
//  NYTimesMostViewedFeedDetailViewController.swift
//  NYTimes
//
//  Created by NIRAV on 6/7/18.
//  Copyright © 2018 NIRAV. All rights reserved.
//

import UIKit
import WebKit

class NYTimesMostViewedFeedDetailViewController: UIViewController,WKNavigationDelegate {
    
    var currentMostViewedResult : MostViewedResults?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do Navigation setup after loading the view.
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.title = NYTimesConfig.StringConstant.ArticleTableViewTitle
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = false
        
        // Loading WebView
        self.initializeWebView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- WKWebBiew Implmentation
    func initializeWebView(){
        //if NYTimesCommonUtils.objectIsValid(feedDictionary) {
        let url = URL(string: currentMostViewedResult?.url ?? "")
        var request: URLRequest? = nil
        if let anUrl = url {
            request = URLRequest(url: anUrl)
        }
        let theConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: view.bounds, configuration: theConfiguration)
        webView.frame = view.frame
        webView.isMultipleTouchEnabled = false
        if let aRequest = request {
            webView.load(aRequest)
        }
        webView.backgroundColor = UIColor.white
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.layoutIfNeeded()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //}
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
