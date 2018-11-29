//
//  NYTimesConfig.swift
//  NYTimesSwift
//
//  Created by Nirav Jain on 07/06/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

import Foundation
import UIKit

struct NYTimesConfig {
    
    //API Keys
    struct APIKey {
        static let NYTimes = "NYTimesAPIKey"
    }
    
    //Back End URLs
    struct BackEndURL {
        static let BaseURL = "https://api.nytimes.com/"
        static var MostPopularViewedArticles = "\(BaseURL)svc/mostpopular/v2/mostviewed/all-sections/7.json?"
    }
    
    //Back End Params
    struct Param {
        static var APIKey = "api-key"
        static var APIValue = "1bdd7e3e3c9b4e2aba6689c50f43b6b0"
        
    }
    
    // Device Width & Heigh Params
    struct Screen {
        static let Width = UIScreen.main.bounds.size.width
        static let Height = UIScreen.main.bounds.size.height
    }
    
    //Constant numerical values
    struct NumberConstant {
        static let ArticleTableRowHeight : CGFloat = 105
    }
    
    struct StringConstant {
        static let ArticleTableViewTitle = "NY Times Most Popular"
    }

}
