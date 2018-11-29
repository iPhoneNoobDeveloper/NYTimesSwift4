//
//  NYTimesMostViewedFeedDataManager.swift
//  NYTimesSwift
//
//  Created by Nirav Jain on 08/06/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

//class NYTimesMostViewedFeedDataManager {
//    static var sharedInstance: NYTimesMostViewedFeedDataManager? = nil
//
//    class func sharedInstance() -> NYTimesMostViewedFeedDataManager? {
//        var onceToken: Int
//        if (onceToken == 0) {
//            self.sharedInstance = NYTimesMostViewedFeedDataManager()
//        }
//        onceToken = 1
//        return sharedInstance
//    }
//}


final class NYTimesMostViewedFeedDataManager{
    static let sharedInstance = NYTimesMostViewedFeedDataManager()
    var mostViewedFeedsArray = [Dictionary<String, Any>]()
    private init() {}
}
