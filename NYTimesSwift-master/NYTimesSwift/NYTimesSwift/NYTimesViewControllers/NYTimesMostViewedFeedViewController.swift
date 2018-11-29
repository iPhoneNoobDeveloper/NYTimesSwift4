//
//  NYTimesMostViewedFeedViewController.swift
//  NYTimesSwift
//
//  Created by Nirav Jain on 07/06/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class Connectivity {
    class var isConnectedToInternet:Bool {
        return (NetworkReachabilityManager()?.isReachable)!
    }
}

class NYTimesMostViewedFeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{

    var refreshControl: UIRefreshControl?
    @IBOutlet var feedTableView: UITableView!
    let searchBar = UISearchBar()
    var searchMode = false
    var mostViewedItemsList : [MostViewedResults]? = Array<MostViewedResults>()
    var filteredSearchResultList : [MostViewedResults]? = nil
    
    var currentOffset = 0
    var totalResults = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do Navigation setup after loading the view.
        self.navigationItem.title = NYTimesConfig.StringConstant.ArticleTableViewTitle
        self.navigationItem.backBarButtonItem?.title  = ""
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.initializeBarButtons()
        
        self.feedTableView.rowHeight = NYTimesConfig.NumberConstant.ArticleTableRowHeight
        self.initilializeRefreshControl()
        
        // Configure Search Bar
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.delegate = self
        
        self.didTapSearchButtonItem((Any).self)
        searchBarCancelButtonClicked(self.searchBar)
        
        // Load Article feeds from NYTimes Server
        loadMostViewFeedsFromServer()
        
    }
    
    
    func initializeBarButtons() {
        
        // Initialize BarButton Items
        let _btn = UIBarButtonItem(image: UIImage(named: "drawer_menu"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = _btn
        let customImg = UIImage(named: "menu")
        let _customButton = UIBarButtonItem(image: customImg, style: .plain, target: nil, action: nil)
        let customImg2 = UIImage(named: "search")
        let _customButton2 = UIBarButtonItem(image: customImg2, style: .plain, target: self, action: #selector(self.didTapSearchButtonItem(_:)))
        
        navigationItem.rightBarButtonItems = [_customButton, _customButton2]
    }

    
    func initilializeRefreshControl() {
        // Initialize refresh control
        if (self.refreshControl == nil) {
            self.refreshControl = UIRefreshControl()
            feedTableView.addSubview(self.refreshControl!)
            self.refreshControl?.backgroundColor = UIColor.lightGray
            self.refreshControl?.tintColor = UIColor.white
            // Configure Refresh Control
            self.refreshControl?.addTarget(self, action: #selector(refreshFeedArticleData(_:)), for: .valueChanged)
        }
    }
    
    // MARK:- NYTimes API Call
    func loadMostViewFeedsFromServer() {
        
        // Load Article feeds from NYTimes Server
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            self.refreshControl?.beginRefreshing()
            NYTimesAFNetworkingWrapper.getJSONFromAPI { (responseModel, error) in
                self.totalResults = (responseModel?.num_results)!
                self.mostViewedItemsList?.append(contentsOf: (responseModel?.results)!)
                self.feedTableView.reloadData()
                self.feedTableView.scrollToRow(at: IndexPath(row: self.currentOffset, section: 0), at: .bottom, animated: false)
                self.refreshControl?.endRefreshing()

            }
        }else{
            print("no internet connection.")
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    // MARK:- Reload & Refresh TableView
    @objc private func refreshFeedArticleData(_ sender: Any) {
        // Fetch Article Data
        loadMostViewFeedsFromServer()
    }
    
    // MARK: reloadDataSoruce
    func reloadFeedTableView() {
        feedTableView.reloadData()
        // End the refreshing
        updateTimerDetails()
        self.refreshControl?.endRefreshing()
    }
    
    func updateTimerDetails() {
        if (self.refreshControl != nil) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            let title = "Last update: \(formatter.string(from: Date()))"
            let attrsDictionary = [NSAttributedStringKey.foregroundColor : UIColor.white]
            let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary)
            refreshControl?.attributedTitle = attributedTitle
        }
    }
    
    @objc func didTapSearchButtonItem(_ sender: Any) {
        
        if self.searchMode == true {
            searchBarCancelButtonClicked(self.searchBar)
            return
        }
        self.searchMode = true
        self.feedTableView.tableHeaderView = searchBar
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
        self.feedTableView.sizeToFit()
        
    }
    
    func resetResults() {
        self.mostViewedItemsList?.removeAll()
        self.currentOffset = 0
    }
    
    func showErrorAlert(message:String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Search Bar
    
//    func filterBySearchKeywords(searchKeyword: String, resultsArray : [Dictionary<String, Any>]()) -> Array<MostViewedResults> {
//
//        if searchKeyword.characters.count == 0 {
//            return resultsArray
//        }
//
//        let filteredArray = resultsArray.filter({
//            (result : MostViewedResults) -> Bool in
//            return (result.title?.localizedCaseInsensitiveContains(searchKeyword))!
//        })
//
//        return filteredArray
//    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchMode = false
        searchBar.resignFirstResponder()
        self.feedTableView.tableHeaderView = nil
        self.feedTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredSearchResultList = NYTimesAppUtilities.filterBySearchKeywords(searchKeyword: searchText, resultsArray: self.mostViewedItemsList!)
        
        self.feedTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }

    // MARK:- UITableView DataSource and Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchMode && self.filteredSearchResultList != nil {
            return (self.filteredSearchResultList?.count)!
        }
        
        if self.searchMode == false && self.mostViewedItemsList != nil {
            return (self.mostViewedItemsList?.count)!
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NYTimesMostViewedFeedTableViewCell"
        var feedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NYTimesMostViewedFeedTableViewCell
    
        if feedCell == nil {
            let nib = Bundle.main.loadNibNamed("NYTimesMostViewedFeedTableViewCell", owner: self, options: nil)
            feedCell = nib?[0] as? NYTimesMostViewedFeedTableViewCell
            feedCell?.selectionStyle = .none
        }
        
        
        //Populate object information to cell
        let object = self.searchMode ? self.filteredSearchResultList?[indexPath.row] : self.mostViewedItemsList?[indexPath.row]

        feedCell?.feedTitleLabel.text = object?.title
        feedCell?.feedTitleLabel.numberOfLines = 0
        feedCell?.feedDescriptionLabel.sizeToFit()
        feedCell?.feedDateLabel.text = "🗓 "+(object?.published_date!)!
        
        
        feedCell?.feedDescriptionLabel.text = object?.byline
        if (feedCell?.feedDescriptionLabel.text?.count)! > 60 {
            feedCell?.feedDescriptionLabel.text = String((feedCell?.feedDescriptionLabel.text?.prefix(60))!) //"123"
        }
    
        
        if let media = object?.media?.first {
            
            if  let metadata = media.media_metadata?.first {
                
                if NYTimesAppUtilities.objectIsValid(metadata.url) {
                
                    let imageURL = URL(string: metadata.url ?? "")
                    // Check if the URL is valid
                    if imageURL != nil {
                        // The URL is valid so we'll use it to load the image asynchronously.
                        feedCell?.feedIconImageView.af_setImage(withURL: (imageURL)!, placeholderImage: nil)
                    } else {
                        // The imageURL is invalid, just show the placeholder image.
                        DispatchQueue.main.async(execute: {
                            feedCell?.feedIconImageView.image = nil
                        })
                    }
                    feedCell?.feedIconImageView.clipsToBounds = true
                }
            }
        }
        
        
        return feedCell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Populate object information to cell
        let object = self.searchMode ? self.filteredSearchResultList?[indexPath.row] : self.mostViewedItemsList?[indexPath.row]
        
        if object != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let feedDetailViewController = storyboard.instantiateViewController(withIdentifier: "NYTimesMostViewedFeedDetailViewController") as? NYTimesMostViewedFeedDetailViewController
            feedDetailViewController?.currentMostViewedResult = object
            if let aController = feedDetailViewController {
                navigationController?.pushViewController(aController, animated: true)
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
