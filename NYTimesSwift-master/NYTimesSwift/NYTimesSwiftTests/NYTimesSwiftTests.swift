//
//  NYTimesSwiftTests.swift
//  NYTimesSwiftTests
//
//  Created by Nirav Jain on 07/06/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

import XCTest
import UIKit

@testable import NYTimesSwift

class NYTimesSwiftTests: XCTestCase {
    
    var storyboard : UIStoryboard?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.storyboard = UIStoryboard(name: "Main",
                                       bundle: Bundle.main)
        
        XCTAssertNotNil(self.storyboard)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testMasterView() {
        
        let masterViewController = self.storyboard?.instantiateViewController(withIdentifier: "NYTimesMostViewedFeedViewController")
        
        XCTAssertNotNil(masterViewController)
        XCTAssertTrue(masterViewController is NYTimesMostViewedFeedViewController)
        
    }
    
    func testMostViewed() {
        
        let expectation = self.expectation(description:  "JSON Response Received")
        
        self.measure {
            // Load Article feeds from NYTimes Server
            if Connectivity.isConnectedToInternet {
                print("Yes! internet is available.")
                NYTimesAFNetworkingWrapper.getJSONFromAPI { (responseModel, error) in
                   expectation.fulfill()
                }
            }else{
                print("no internet connection.")
            }
        }
        
        self.waitForExpectations(timeout: 30) { error in
            XCTAssertNil(error)
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
