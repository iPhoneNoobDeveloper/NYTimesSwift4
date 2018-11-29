//
//  NYTimesAppUtilities.swift
//  NYTimesSwift
//
//  Created by Nirav Jain on 07/06/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

import UIKit

class NYTimesAppUtilities: NSObject {
    class func objectIsValid(_ object: Any?) -> Bool {
        if NSNull() != (object as? NSNull) && nil != object && (object is String) && ((object as? String)?.count ?? 0) > 0 {
            return true
        } else if NSNull() != (object as? NSNull) && nil != object && (object is [Any]) && ((object as? [Any])?.count ?? 0) > 0 {
            return true
        } else if NSNull() != (object as? NSNull) && nil != object && (object is [AnyHashable]) && ((object as? [AnyHashable])?.count ?? 0) > 0 {
            return true
        } else if NSNull() != (object as? NSNull) && nil != object && (object is [AnyHashable: Any]) && (object as? [AnyHashable: Any])?.count ?? 0 > 0 {
            return true
        } else if NSNull() != (object as? NSNull) && nil != object && (object is [AnyHashable: Any]) && (object as? [AnyHashable: Any])?.count ?? 0 > 0 {
            return true
        } else if NSNull() != (object as? NSNull) && nil != object && (object is Date) {
            return true
        } else if NSNull() != (object as? NSNull) && nil != object && (object is NSNumber) {
            return true
        } else {
            return false
        }
    }
    
    public class func configTest(){
        NYTimesConfig.BackEndURL.MostPopularViewedArticles = "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?"
        NYTimesConfig.Param.APIKey = "api-key"
        NYTimesConfig.Param.APIValue = "abc"
    }
    
    class func filterBySearchKeywords(searchKeyword: String, resultsArray : Array<MostViewedResults>) -> Array<MostViewedResults> {
        
        if searchKeyword.characters.count == 0 {
            return resultsArray
        }
        
        let filteredArray = resultsArray.filter({
            (result : MostViewedResults) -> Bool in
            return (result.title?.localizedCaseInsensitiveContains(searchKeyword))!
        })
        
        return filteredArray
    }
}
