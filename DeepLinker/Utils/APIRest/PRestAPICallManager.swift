//
//  PRestAPICallMAnager.swift
//  Padam
//
//  Created by PadamBus on 11/01/2016.
//  Copyright © 2016 OPTIWAYS SAS. All rights reserved.
//

import SystemConfiguration
import Foundation
//import Reachability

/********
API call parameters
********/
public let DEFAULT_TIMOUT = 30.0

/********
API response managing
********/
let API_ERROR_DOMAIN = "Padam API Error"
let TIMEOUT_ERROR_DOMAIN = "TimeOut Error"
let HTTP_ERROR_DOMAIN = "HTTP Error"
let API_SUCCES_RESPONSE = "OK"


protocol JSONSerializable {
    var jsonDictionary:NSDictionary? {get}
    init(jsonResponse:NSDictionary)
}

let BACKGROUND_QUEUE_NAME = "backgroundQueue"
public enum HTTPVerb:String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

public class PRestAPICallManager {    
    
// MARK: - Any API call
    
    public class func restAPICall(
        _ callType:HTTPVerb,
    url:URL,
    postParams:[String: AnyObject]?,
    timeOut:TimeInterval = DEFAULT_TIMOUT,
    accessToken:String?,
    login:String? = nil,
    password:String? = nil,
    dispatchQueue:DispatchQueue = DispatchQueue.main,
    success: @escaping (_ jsonResponse:Any?,_ response:URLResponse, _ request:URLRequest) -> (),
    failure:@escaping (_ error:NSError, _ request:URLRequest) -> ()) {
        //create url and session object
        let session = URLSession.shared
        // Create the request
        var request = URLRequest(url:url)
        request.httpMethod = callType.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeOut
        if let token = accessToken {
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        if let login = login, let password = password, let loginData = "\(login):\(password)".data(using: .utf8) {
            //let loginData = "\(login):\(password)"
            let base64LoginData = loginData.base64EncodedString()
            request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        }
        //print(request.allHTTPHeaderFields!)
        //put parameters in the body
        if let params = postParams {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                //print(params)
            } catch {
                print("bad things happened for body post request serialization")
            }
        }
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        //Make the request
        let task = session.dataTask(with:request, completionHandler: { (data, response, error) -> Void in
            print("responseURL: \(String(describing: response?.url))")
            if let responseData = data, let APIResponse = response, let jsonSerialized = try? JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers) {
                dispatchQueue.async {
                    //print("response \(jsonDictionary as NSDictionary)")
                    success(jsonSerialized, APIResponse, request)
                }
            } else if let APIResponse = response, let code = (APIResponse as? HTTPURLResponse)?.statusCode, (200...299).contains(code) {
                dispatchQueue.async {
                    //print("response \(jsonDictionary as NSDictionary)")
                    success(nil, APIResponse, request)
                }
            }  else {
                (error == nil) ? print("HTTPError"):print("error: \(error!.localizedDescription)")
                dispatchQueue.async {
                    failure(PRestAPICallManager.formatHTTPError(error: error, response: response), request)
                }
            }
            
        })
        task.resume()
    }
    
    
//MARK: Build any type of error
    
    //build swift error with HTTP error
    class func buildHTTPError (_ response :URLResponse) -> NSError {
        let statusCode = (response as? HTTPURLResponse)!.statusCode
        let description = HTTP_ERROR_MESSAGE_BEGININ + "\(statusCode)" + HTTP_ERROR_MESSAGE_END
        return NSError(domain: HTTP_ERROR_DOMAIN, code: statusCode, userInfo: [NSLocalizedDescriptionKey : description])
    }
    
    class func buildUnknowError() -> NSError {
        let statusCode:Int = 3001
        let description = HTTP_ERROR_MESSAGE_BEGININ + "\(statusCode)" + HTTP_ERROR_MESSAGE_END + HTTP_3000_ERROR_END_MESSAGE
        return NSError(domain: HTTP_ERROR_DOMAIN, code: statusCode, userInfo: [NSLocalizedDescriptionKey : description])
    }
    
    class func NoNetworkError() -> NSError {
        let statusCode:Int = 3002
        let description = NETWORK_ERROR_MESSAGE
        return NSError(domain: HTTP_ERROR_DOMAIN, code: statusCode, userInfo: [NSLocalizedDescriptionKey : description])
    }
    
    class func formatHTTPError(error:Error?, response:URLResponse?) -> NSError {
        let errorNS:NSError
        if let responseHttp = response {
            errorNS = self.buildHTTPError(responseHttp)
            
        } else if let errorResponse = error {
            if ((errorResponse as NSError).code == -1001) {
                errorNS = NSError(domain: TIMEOUT_ERROR_DOMAIN, code: (errorResponse as NSError).code, userInfo: [NSLocalizedDescriptionKey : TIMEOUT_ERROR_MESSAGE])
            } else {
                errorNS = errorResponse as NSError//self.buildUnknownHTTPError(errorResponse as NSError)
            }
        } else {
            errorNS = self.buildUnknowError()
        }
        
        return errorNS
    }
}


// MARK: - Models filling methods

//extension function to fill all models' object with JSON response and their own properties correspondance with backend models' properties
//extension NSObject {
//    func fillWithJSON(_ jsonrespond:NSDictionary, propertyCorrespondance:NSDictionary? = nil) {
//        for (key, value) in jsonrespond {
//            //Check if JSON's property correspond to a swift model's property
//            let keyName: String
//            if let propCorr = propertyCorrespondance, let propName = propCorr.object(forKey: key) as? String {
//                keyName = propName
//            } else {
//                keyName = key as! String
//            }
//            // If property exists
//            if (self.responds(to: NSSelectorFromString(keyName))) {
//                if (value as? NSNull) == nil && (value  as? NSDictionary) == nil && (value  as? NSArray) == nil {
//                    self.setValue(value, forKey: keyName)
//                } else if let valueDictionary = value as? NSDictionary, let property = self.value(forKey:keyName) as? JSONSerializable {
//                    let propertieValue = type(of:property).init(jsonResponse:valueDictionary)
//                    self.setValue(propertieValue, forKey: keyName )
//                }
//            }
//        }
//    }
//}

