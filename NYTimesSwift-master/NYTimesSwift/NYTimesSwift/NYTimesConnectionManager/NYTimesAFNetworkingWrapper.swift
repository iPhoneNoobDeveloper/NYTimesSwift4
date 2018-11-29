//
//  NYTimesAFNetworkingWrapper.swift
//  NYTimesSwift
//
//  Created by Nirav Jain on 07/06/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

import UIKit
import Alamofire

class NYTimesAFNetworkingWrapper: NSObject {
    public class func getJSONFromAPI(closure: @escaping (MostViewedResponse?, Error?) -> Void){
      
        let RequestString = "\(NYTimesConfig.BackEndURL.MostPopularViewedArticles)\(NYTimesConfig.Param.APIKey)=\(NYTimesConfig.Param.APIValue)"
        Alamofire.request(RequestString).responseJSON { (responseData) -> Void in
            
            var statusCode = responseData.response?.statusCode
            
            if let error = responseData.result.error as? AFError {
                statusCode = error._code // statusCode private
                switch error {
                case .invalidURL(let url):
                    print("Invalid URL: \(url) - \(error.localizedDescription)")
                case .parameterEncodingFailed(let reason):
                    print("Parameter encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .multipartEncodingFailed(let reason):
                    print("Multipart encoding failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                case .responseValidationFailed(let reason):
                    print("Response validation failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                    
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        print("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        print("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        print("Response status code was unacceptable: \(code)")
                        statusCode = code
                    }
                case .responseSerializationFailed(let reason):
                    print("Response serialization failed: \(error.localizedDescription)")
                    print("Failure Reason: \(reason)")
                    // statusCode = 3840 ???? maybe..
                }
                
            } else if let error = responseData.result.error as? URLError {
                print("URLError occurred: \(error)")
            } else {
                if statusCode == 200{
                    if((responseData.result.value) != nil) {
                        print(responseData.result.value!)
                        
                        if let json = responseData.result.value as? Dictionary<String, AnyObject> {
                            
                            let responseModel = MostViewedResponse(dictionary: json as! NSDictionary)
                            
                            closure(responseModel, responseData.result.error)
                            
                           
                        }
                    }
                }
            }
            
            
        }
        
       
    
    }
}
